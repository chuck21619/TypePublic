//
//  TextStorageDelegateHandler.swift
//  TextEditor
//
//  Created by charles johnston on 9/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation


// TODO: rename protocol
protocol TextStorageDelegateHandlerDelegate {
    
    func invalidateRanges(invalidRanges: [NSRange])
}

class TextStorageDelegateHandler: NSObject, NSTextStorageDelegate {
    
    // MARK: - Properties
    var delegate: TextStorageDelegateHandlerDelegate? = nil
    
    private let syntaxParser = SyntaxParser()
    private var editedRange: NSRange = NSRange(location: 0, length: 0)
    private var changeInLength: Int = 0
    private var backingStore = NSTextStorage()
    private var skipPass = false
    private var editedRangeSinceLastParsing: NSRange? = nil
    private var changeInLengthSinceLastParsing: Int? = nil
    private var workItem: DispatchWorkItem? = nil
    
    // MARK: - methods
    private func updateSyntax(searchRange: NSRange) {
        
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
                
                self.skipPass = true
                self.backingStore.beginEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
                for invalidAttributeRange in invalidAttributeRanges {
                    
                    self.backingStore.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
                    self.backingStore.addAttribute(normalFontAttribute.key, value: normalFontAttribute.value, range: invalidAttributeRange)
                }
                
                for attributeOccurence in newAttributeOccurrences {
                    
                    self.backingStore.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
                }
                self.backingStore.endEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
                self.skipPass = false
                let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
                    return attributeOccurence.effectiveRange
                })
                
                let invalidRanges = invalidAttributeRanges + newAttributesRanges
                
                self.delegate?.invalidateRanges(invalidRanges: invalidRanges)
            }
            
            newWorkItem = nil
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
    
    // MARK: - NSTextStorageDelegate
    func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        // TODO: find a better way to do this. purpose is to prevent an infinite loop
        if skipPass == true {
            return
        }
        
        self.editedRange = editedRange
        self.changeInLength = delta
        self.backingStore = textStorage
        
        updateSyntax(searchRange: backingStore.string.maxNSRange)
    }
}
