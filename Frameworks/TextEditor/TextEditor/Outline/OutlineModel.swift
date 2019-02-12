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
    private var string: String = ""
    var parentTextGroup: TextGroup = TextGroup(title: "parent")
    private var workItem: DispatchWorkItem? = nil
    
    // MARK: - Methods
    // MARK: Constructor
    init(language: Language, delegate: OutlineModelDelegate?) {
        
        self.language = language
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
        
        self.string = string.string
        self.parentTextGroup = parentTextGroup
        completion?(parentTextGroup)
    }
    
    func reCalculateTextGroups(editedRange: NSRange, delta: Int) {
        
        for textGroup in self.parentTextGroup {
            
            guard let textGroupRange = range(of: textGroup) else {
                continue
            }
            
            if textGroupRange.location + textGroupRange.length <= editedRange.location &&
                textGroupRange.location + textGroupRange.length <= editedRange.location + editedRange.length {
                
                print("")
                //do nothing
                //the textgroup is prior to the edit, and will not be changed
            }
            else if textGroupRange.location >= editedRange.location &&
                textGroupRange.location >= editedRange.location + editedRange.length {
                
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
            }
        }
    }
    
    func reCalculateTextGroups(replacingRange: NSRange, with str: String) {
        
       reCalculateTextGroups(editedRange: replacingRange, delta: str.count - replacingRange.length)
    }
    
    func textGroup(at location: Int) -> TextGroup? {
        
        var textGroup: TextGroup?
        
        for iteratedTextGroup in parentTextGroup {
            
            if iteratedTextGroup.token?.range.location == location {
                textGroup = iteratedTextGroup
                break
            }
        }
        
        return textGroup
    }
    
    func range(of textGroup: TextGroup, includeTitle: Bool = true) -> NSRange? {
        
        guard let parent = textGroup.parentTextGroup else {
            
            //if there is no parent, than it is the root group
            return string.maxNSRange
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
            
            guard let parentTextGroupRange = range(of: parent) else {
                return nil
            }
                
            endOfTextGroup = parentTextGroupRange.location + parentTextGroupRange.length
        }
        
        let length = endOfTextGroup - location
        
        return NSRange(location: location, length: length)
    }
    
    func nextTextGroupWithEqualOrHigherPriority(after textGroup: TextGroup) -> TextGroup? {
        
        guard let textGroups = textGroup.parentTextGroup?.textGroups else {
            return nil
        }
        
        guard let indexOfTextGroupInParent = textGroups.firstIndex(of: textGroup) else {
            return nil
        }
        
        let startIndex = indexOfTextGroupInParent + 1
        
        guard let textGroupToken = textGroup.token else {
            return nil
        }
        
        var nextTextGroupWithEqualOrHigherPriority: TextGroup? = nil
        
        for i in startIndex..<textGroups.count {
            
            let textGroup = textGroups[i]
            guard let iteratedToken = textGroup.token else {
                continue
            }
            
            if language.priority(of: iteratedToken, isHigherThan: textGroupToken) ||
               language.priority(of: iteratedToken, isEqualTo: textGroupToken) {
                
                nextTextGroupWithEqualOrHigherPriority = textGroup
                break
            }
        }
        

        if nextTextGroupWithEqualOrHigherPriority == nil,
           let parentTextGroup = textGroup.parentTextGroup {
            
            return self.nextTextGroupWithEqualOrHigherPriority(after: parentTextGroup)
        }
        
        return nextTextGroupWithEqualOrHigherPriority
    }
}
