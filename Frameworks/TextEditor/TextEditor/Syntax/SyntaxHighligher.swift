//
//  TextStorageDelegateHandler.swift
//  TextEditor
//
//  Created by charles johnston on 9/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SyntaxHighligher: NSObject, NSTextStorageDelegate {
    
    // MARK: - Properties
    var delegate: SyntaxHighlighterDelegate? = nil
    
    private let syntaxParser = SyntaxParser()
    private var skipPass = false
    private var workItem: DispatchWorkItem? = nil
    
    // keep track of any request's edits, in case a new request is made before completion
    private var editedRangeSinceLastParsing: NSRange? = nil
    private var changeInLengthSinceLastParsing: Int? = nil
    
    //TODO: get font from settings
    private let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
    private let normalFontAttribute = Attribute(key: .font, value: NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11))
    
    // MARK: - methods
    func highlight(editedRange: NSRange, changeInLength: Int, textStorage: NSTextStorage) {
        
        guard skipPass == false else {
            
            return
        }
        
        let searchRange = textStorage.string.maxNSRange
        
        self.editedRangeSinceLastParsing = self.editedRangeSinceLastParsing?.union(editedRange) ?? editedRange
        self.changeInLengthSinceLastParsing = (self.changeInLengthSinceLastParsing ?? 0) + changeInLength
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            guard let editedRange = self.editedRangeSinceLastParsing,
                  let changeInLength = self.changeInLengthSinceLastParsing else {
                    return
            }
            
            guard let attributeOccurrences = self.syntaxParser.attributeOccurrences(for: textStorage.string, range: searchRange, editedRange: editedRange, changeInLength: changeInLength, workItem: newWorkItem) else {
                return
            }
            let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
            let invalidAttributeRanges = attributeOccurrences.invalidRanges
            
            self.editedRangeSinceLastParsing = nil
            self.changeInLengthSinceLastParsing = nil
            
            DispatchQueue.main.async {
                
                self.skipPass = true
                textStorage.beginEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
                for invalidAttributeRange in invalidAttributeRanges {
                    
                    textStorage.addAttribute(self.normalColorAttribute.key, value: self.normalColorAttribute.value, range: invalidAttributeRange)
                    textStorage.addAttribute(self.normalFontAttribute.key, value: self.normalFontAttribute.value, range: invalidAttributeRange)
                }
                
                for attributeOccurence in newAttributeOccurrences {
                    
                    textStorage.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
                }
                textStorage.endEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
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
}
