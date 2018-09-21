//
//  TextStorageDelegateHandler.swift
//  TextEditor
//
//  Created by charles johnston on 9/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation


protocol TextStorageDelegateHandlerDelegate {
    
    func didChangeAttributeOccurrences(changedAttributeOccurrences: [AttributeOccurrence])
    func invalidateRanges(invalidRanges: [NSRange])
}

class TextStorageDelegateHandler: NSObject, NSTextStorageDelegate {
    
    let syntaxParser = SyntaxParser()
    var myDelegate: TextStorageDelegateHandlerDelegate? = nil
    
    var editedRange: NSRange = NSRange(location: 0, length: 0)
    var changeInLength: Int = 0
    var backingStore = NSTextStorage()
    
    
    var lastParsedString = ""
    
    func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        // TODO: this condition isnt always valid (it does not take attributes into account)
        // find a better way to do this. the purpose is to prevent an infinite loop
        guard lastParsedString != textStorage.string else {
            return
        }
        
        self.editedRange = editedRange
        self.changeInLength = delta
        self.backingStore = textStorage
        
        updateSyntax(searchRange: backingStore.string.maxNSRange)
        
        self.lastParsedString = textStorage.string
    }
    
    
    var editedRangeSinceLastParsing: NSRange? = nil
    var changeInLengthSinceLastParsing: Int? = nil
    
    var workItem: DispatchWorkItem? = nil
    
    func updateSyntax(searchRange: NSRange) {
        
        print("updateSyntax")
        
        self.editedRangeSinceLastParsing = self.editedRangeSinceLastParsing?.union(editedRange) ?? editedRange
        self.changeInLengthSinceLastParsing = (self.changeInLengthSinceLastParsing ?? 0) + changeInLength
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            guard let editedRange = self.editedRangeSinceLastParsing,
                let changeInLength = self.changeInLengthSinceLastParsing else {
                    return
            }
            
            // get attributes from syntax parser
            guard let attributeOccurrences = self.syntaxParser.attributeOccurrences(for: self.backingStore.string, range: searchRange, editedRange: editedRange, changeInLength: changeInLength, workItem: newWorkItem) else {
                return
            }
            let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
            let invalidAttributeRanges = attributeOccurrences.invalidRanges
            let allAttributeOccurrences = attributeOccurrences.allAttributeOccurrences
            
            let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
            //TODO: get font from settings
            let normalFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
            let normalFontAttribute = Attribute(key: .font, value: normalFont)
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            self.editedRangeSinceLastParsing = nil
            self.changeInLengthSinceLastParsing = nil
            
            //TODO: figure out a good way to do this
            //the reason it was moved it here: when the pass is abandoned, syntax parser still sets the lastAttributes - so when the next successful pass happens, it is basing it's algorithm on invalid data becuase the lastAttributes is used to calcuated what needs to be updated
            self.syntaxParser.lastAttributeOccurrences = allAttributeOccurrences
            
            DispatchQueue.main.async {
                
                // invalidating must happen first and new attributes may include the invalid ranges - this might not be correct
                //TODO: consolidate invalid and new attributes
                for invalidAttributeRange in invalidAttributeRanges {
                    
                    self.backingStore.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
                    self.backingStore.addAttribute(normalFontAttribute.key, value: normalFontAttribute.value, range: invalidAttributeRange)
                }
                
                for attributeOccurence in newAttributeOccurrences {
                    
                    self.backingStore.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
                }
                
                let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
                    return attributeOccurence.effectiveRange
                })
                
                let invalidRanges = invalidAttributeRanges + newAttributesRanges
                
                self.myDelegate?.invalidateRanges(invalidRanges: invalidRanges)
            }
            
            newWorkItem = nil
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
}
