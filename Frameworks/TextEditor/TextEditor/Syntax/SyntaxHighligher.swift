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
    
    private let syntaxParser: SyntaxParser
    private var workItem: DispatchWorkItem? = nil
    
    // keep track of any request's edits, in case a new request is made before completion
    private var editedRangeSinceLastParsing: NSRange? = nil
    private var changeInLengthSinceLastParsing: Int? = nil
    
    //TODO: get font from settings
    private let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
    
    //MARK: - Constructors
    init(syntaxParser: SyntaxParser) {
        
        self.syntaxParser = syntaxParser
    }
    
    // MARK: - methods
    func highlight(editedRange: NSRange, changeInLength: Int, textStorage: NSTextStorage, completion: ((_ invalidRanges: [NSRange])->())? = nil) {
        
        self.editedRangeSinceLastParsing = self.editedRangeSinceLastParsing?.union(editedRange) ?? editedRange
        self.changeInLengthSinceLastParsing = (self.changeInLengthSinceLastParsing ?? 0) + changeInLength
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            let string = textStorage.string
            let range = string.maxNSRange
            
            guard let editedRange = self.editedRangeSinceLastParsing,
                  let changeInLength = self.changeInLengthSinceLastParsing,
                  let attributeOccurrences = self.syntaxParser.newAttributeOccurrences(for: string, range: range, editedRange: editedRange, changeInLength: changeInLength, workItem: newWorkItem) else {
                    return
            }
            
            let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
            let invalidAttributeRanges = attributeOccurrences.invalidRanges
            
            self.editedRangeSinceLastParsing = nil
            self.changeInLengthSinceLastParsing = nil
            
            DispatchQueue.main.async {
            
                self.addAttributes(textStorage: textStorage, invalidAttributeRanges: invalidAttributeRanges, newAttributeOccurrences: newAttributeOccurrences)
            
                let invalidRanges = self.invalidRanges(newAttributeOccurrences: newAttributeOccurrences, invalidAttributeRanges: invalidAttributeRanges)
                completion?(invalidRanges)
            }
            
            newWorkItem = nil
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
    
    private func addAttributes(textStorage: NSTextStorage, invalidAttributeRanges: [NSRange], newAttributeOccurrences: [AttributeOccurrence]) {
        
        self.delegate?.willAddAttributes(self)
//        textStorage.beginEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
        for invalidAttributeRange in invalidAttributeRanges {
            
            textStorage.addAttribute(self.normalColorAttribute.key, value: self.normalColorAttribute.value, range: invalidAttributeRange)
        }
        
        for attributeOccurence in newAttributeOccurrences {
            
            textStorage.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
        }
//        textStorage.endEditing() // TODO: this is added as a test - not sure if this helps or breaks stuff
        self.delegate?.didAddAttributes(self)
    }
    
    private func invalidRanges(newAttributeOccurrences: [AttributeOccurrence], invalidAttributeRanges: [NSRange]) -> [NSRange] {
        
        let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
            return attributeOccurence.effectiveRange
        })
        
        let invalidRanges = invalidAttributeRanges + newAttributesRanges
        
        return invalidRanges
    }
}
