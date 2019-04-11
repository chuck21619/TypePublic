//
//  OutlineModel.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineModel {
    
    // MARK: - Properties
    var delegate: OutlineModelDelegate?
    var processing: Bool = false // TODO: implement - used by OutlineViewController.allowInteraction
    let language: Language
    var parentTextGroup: TextGroup = TextGroup(title: "parent")
    let collapsingTranslator: CollapsingTranslator
    private var workItem: DispatchWorkItem? = nil
    
    // MARK: - Methods
    // MARK: Constructor
    init(language: Language, collapsingTranslator: CollapsingTranslator, delegate: OutlineModelDelegate?) {
        
        self.language = language
        self.collapsingTranslator = collapsingTranslator
        self.delegate = delegate
    }
    
    // MARK: real stuff
    func outline(textStorage: NSMutableAttributedString, _ completion: (()->())? = nil ) {
        
        let string = NSMutableAttributedString(attributedString: textStorage)
        
        updateTextGroups(from: string, completion: { (parentTextGroup) in
            
            self.delegate?.didUpdate(parentTextGroup: parentTextGroup)
            completion?()
        })
    }
    
    func updateTextGroups(from string: NSMutableAttributedString, workItem: DispatchWorkItem? = nil, completion: ((TextGroup?)->())? = nil) {
        
        //TODO: change the dependancy on this method - several operations in textHighlthing/collapsing have to keep calling this method in order to have updated groups
        
        guard let tokens = self.language.textGroupTokens(for: string.string, workItem: workItem) else {
            completion?(nil)
            return
        }
        
        let parentTextGroup = TextGroup (title: "parent")
        
        for token in tokens {
            
            let newTextGroup = TextGroup(title: token.label, token: token)
            
            var flattenedTextGroups: [TextGroup] = []
            
            for textGroup in parentTextGroup {
                
                flattenedTextGroups.append(textGroup)
            }
            
            let reversedTextGroups =  flattenedTextGroups.reversed()
            
            var noPreviousTextGroupsWithHigherPriority = true
            for textGroup in reversedTextGroups {
                
                guard let textGroupToken = textGroup.token else {
                    continue
                }
                
                if self.language.priority(of: textGroupToken, isHigherThan: token) {
                    
                    textGroup.textGroups.append(newTextGroup)
                    
                    noPreviousTextGroupsWithHigherPriority = false
                    break
                }
            }
            
            if noPreviousTextGroupsWithHigherPriority {
                
                parentTextGroup.textGroups.append(newTextGroup)
            }
            
            
            guard workItem?.isCancelled != true else {
                print("cancallineg thins shiots")
                completion?(nil)
                return
            }
        }
        
        self.parentTextGroup = parentTextGroup
        updateCollapsingTranslatorsTextGroups()

        completion?(parentTextGroup)
    }
    
    //expandingTextGroup is the text group that is currently being expanding which is causing the recalculation of text groups
    func reCalculateTextGroups(editedRange: NSRange, delta: Int, expandingTextGroup: TextGroup? = nil, downwardDraggingGroup: TextGroup? = nil, removingTextGroup: TextGroup?) {
        
        for textGroup in self.parentTextGroup {
            
            guard textGroup != removingTextGroup else {
                continue
            }
            
            guard let textGroupRange = textGroup.token?.range else {
                continue
            }
            
            if textGroupRange.location + textGroupRange.length <= editedRange.location &&
                textGroupRange.location + textGroupRange.length <= editedRange.location + editedRange.length {
                
                //print("")
                //do nothing
                //the textgroup is prior to the edit, and will not be changed
            }
            else if (textGroupRange.location >= editedRange.location &&
                     textGroupRange.location >= editedRange.location + editedRange.length) ||
                    (textGroup == downwardDraggingGroup) {
                
                if let expandingTextGroup = expandingTextGroup {
                    // if the textgroup is a descendant of the textgroup than the range should not need to be recalculated
                    guard textGroup.isDescendant(of: expandingTextGroup) == false else {
                        continue
                    }
                }
                
                guard let previousTokenRange = textGroup.token?.range else {
                    continue
                }
                
                let newLocation = previousTokenRange.location + delta
                
                let newTokenRange = NSRange(location: newLocation, length: previousTokenRange.length)
                
                textGroup.token?.range = newTokenRange
                
                //the textgroup is completely after the edit, and will be adjusted by the same as the edit delta
            }
            else {
                
                //TODO: figure out the other scenarios - not sure how many more there are
                print("ERROR RECALCULATING TEXT GROUPS - INCOMPLETE IMPLEMENTATION")
            }
        }
    }
    
    func reCalculateTextGroups(replacingRange: NSRange, with str: String, expandingTextGroup: TextGroup?, downwardDraggingGroup: TextGroup?, removingTextGroup: TextGroup?) {
        
        reCalculateTextGroups(editedRange: replacingRange, delta: str.count - replacingRange.length, expandingTextGroup: expandingTextGroup, downwardDraggingGroup: downwardDraggingGroup, removingTextGroup: removingTextGroup)
    }
    
    //collapsedTextGroups: if passed. then the location will be adjusted to account for the collapsed groups
    func textGroup(at location: Int, collapsedTextGroups: [TextGroup]) -> TextGroup? {
        
        var adjustedLocation = location
        
        for collapsedTextGroup in collapsedTextGroups {
            
            if let collapsedParentTextGroup = collapsedTextGroup.parentTextGroup {
                
                guard collapsedTextGroups.contains(collapsedParentTextGroup) == false else {
                    continue
                }
            }
            
            guard let range = collapsedTextGroup.token?.range else {
                continue
            }
            
            if range.location < adjustedLocation {
                let range = self.range(of: collapsedTextGroup, in: delegate!.documentString()!, includeTitle: false)
                adjustedLocation += range!.length
                adjustedLocation -= 1 // account for replacing the attachment image
            }
        }
        
        
        var textGroup: TextGroup?
        
        for iteratedTextGroup in parentTextGroup {
            
            if iteratedTextGroup.token?.range.location == adjustedLocation {
                textGroup = iteratedTextGroup
                break
            }
        }
        
        return textGroup
    }
    
    func range(of textGroup: TextGroup, in string: NSMutableAttributedString, includeTitle: Bool = true) -> NSRange? {
        
        guard let parent = textGroup.parentTextGroup else {
            
            //if there is no parent, than it is the root group
            return string.string.maxNSRange
        }
        
        let location: Int
        
        if includeTitle {
            
            guard let tmpLocation = textGroup.token?.range.location else {
                return nil
            }
            location = tmpLocation
        }
        else {
            
            location = textGroup.token!.range.location + textGroup.token!.range.length
        }
        
        let endOfTextGroup: Int
        
        // find the next text group with equal or higher priority
        if let nextTextGroupWithEqualOrHigherPriority = self.nextTextGroupWithEqualOrHigherPriority(after: textGroup),
           let locationOfNextTextGroupWithEqualOrHigherPriority = nextTextGroupWithEqualOrHigherPriority.token?.range.location {
         
            if includeTitle {
                
                
                endOfTextGroup = locationOfNextTextGroupWithEqualOrHigherPriority
            }
            else {
                
                
                endOfTextGroup = locationOfNextTextGroupWithEqualOrHigherPriority - 1
            }
        }
        // if there is no following text group (that is equal or higher) within its own parent,
        // then the end of the text group would be the end of the parent text group
        else {
            
            guard let parentTextGroupRange = range(of: parent, in: string) else {
                return nil
            }
                
            endOfTextGroup = parentTextGroupRange.location + parentTextGroupRange.length
        }
        
        let length = endOfTextGroup - location
        
        return NSRange(location: location, length: length)
    }
    
    func nextTextGroupWithEqualOrHigherPriority(after textGroup: TextGroup) -> TextGroup? {
        
        var flattenedTextGroups: [TextGroup] = []
        for textGroup in parentTextGroup {
            flattenedTextGroups.append(textGroup)
        }
        
        let sortedTextGroups = (flattenedTextGroups).sorted { (firstTextGroup, secondTextGroup) -> Bool in
            return firstTextGroup.token?.range.location ?? 0 < secondTextGroup.token?.range.location ?? 0
        }
        
        guard let startIndex = sortedTextGroups.firstIndex(of: textGroup) else {
            return nil
        }
        
        guard let textGroupToken = textGroup.token else {
            return nil
        }
        
        var nextTextGroupWithEqualOrHigherPriority: TextGroup? = nil
        
        for i in startIndex..<sortedTextGroups.count {
            
            let iteratedTextGroup = sortedTextGroups[i]
            guard let iteratedToken = iteratedTextGroup.token else {
                continue
            }
            
            if language.priority(of: iteratedToken, isHigherThan: textGroupToken) ||
               language.priority(of: iteratedToken, isEqualTo: textGroupToken) &&
               textGroup != iteratedTextGroup {
                
                nextTextGroupWithEqualOrHigherPriority = iteratedTextGroup
                break
            }
        }
        

        if nextTextGroupWithEqualOrHigherPriority == nil,
           let parentTextGroup = textGroup.parentTextGroup {
            
            return self.nextTextGroupWithEqualOrHigherPriority(after: parentTextGroup)
        }
        
        return nextTextGroupWithEqualOrHigherPriority
    }
    
    func updateCollapsingTranslatorsTextGroups() {
        
        for collapsedTextGroup in collapsingTranslator.collapsedTextGroups {
            
            for newTextGroup in self.parentTextGroup {
                
                if collapsedTextGroup.title == newTextGroup.title && collapsedTextGroup.token == newTextGroup.token {
                    
                    let index = collapsingTranslator.collapsedTextGroups.firstIndex(of: collapsedTextGroup)
                    collapsingTranslator.collapsedTextGroups[index!] = newTextGroup
                }
            }
        }
    }
}
