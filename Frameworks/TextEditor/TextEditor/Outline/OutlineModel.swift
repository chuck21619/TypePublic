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
    var textGroups: [TextGroup] = []
    private var workItem: DispatchWorkItem? = nil
    
    // MARK: - Methods
    // MARK: Constructor
    init(language: Language, delegate: OutlineModelDelegate?) {
        
        self.language = language
        self.delegate = delegate
    }
    
    // MARK: real stuff
    func outline(textStorage: NSTextStorage, _ completion: (()->())? = nil ) {
        
        updateTextGroups(from: textStorage.string, completion: { (textGroups) in
            
            self.delegate?.didUpdate(textGroups: textGroups)
            completion?()
        })
    }
    
    func updateTextGroups(from string: String, completion: (([TextGroup]?)->())? = nil) {
        
//        workItem?.cancel()
//        var newWorkItem: DispatchWorkItem!
//        
//        newWorkItem = DispatchWorkItem {
            
            guard let tokens = self.language.textGroupTokens(for: string, workItem: nil/*newWorkItem*/) else {
                completion?(nil)
                return
            }
            
            var textGroups: [TextGroup] = []
            
            for token in tokens {
                
                var title = token.label
                
                //TODO: the following 3 lines of code: this is not a valid solution to identifying/removing the collapsed image in a token
                // user could have his own image on the end of a token which would also cause this to be true, which would be invalid as the text group is not necessariyly collapsed
                // i think the best valid solution will have to be to change all the string arguments to nsattributedstring and then look at the attributedString for a testTextAttachment
                if let lastCharacter = token.label.last, String(lastCharacter).utf8.count > 1 {
                    
                    title.removeLast()
                }
                
                let newTextGroup = TextGroup(title: title, token: token)
                
                var flattenedTextGroups: [TextGroup] = []
                
                let iterator = TextGroupIterator(textGroups: textGroups)
                while let textGroup = iterator.next() {
                    
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
                    
                    textGroups.append(newTextGroup)
                }
            }
            
            self.string = string
            self.textGroups = textGroups
            completion?(textGroups)
            
//            newWorkItem = nil
//        }
//        self.workItem = newWorkItem
        
//        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
    
    func textGroup(at location: Int) -> TextGroup? {
        
        let parentTextGroup = TextGroup(title: "parent", textGroups: textGroups, token: nil)
        
        var textGroup = textGroups.first
        let iterator = parentTextGroup.createIterator()
        
        while textGroup != nil {
            
            if textGroup?.token?.range.location == location {
                break
            }
            
            textGroup = iterator.next()
        }
        
        return textGroup
    }
    
    func range(of textGroup: TextGroup) -> NSRange? {
        
        guard let parent = textGroup.parentTextGroup else {
            
            //if there is no parent, than it is the root group
            return string.maxNSRange
        }
        
        guard let location = textGroup.token?.range.location else {
            return nil
        }
        
        let endOfTextGroup: Int
        
        // find the next text group with equal or higher priority
        if let nextTextGroupWithEqualOrHigherPriority = self.nextTextGroupWithEqualOrHigherPriority(after: textGroup),
           let locationOfNextTextGroupWithEqualOrHigherPriority = nextTextGroupWithEqualOrHigherPriority.token?.range.location {
         
            endOfTextGroup = locationOfNextTextGroupWithEqualOrHigherPriority
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
