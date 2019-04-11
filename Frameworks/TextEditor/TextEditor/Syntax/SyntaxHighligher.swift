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
    var delegate: IgnoreProcessingDelegate? = nil
    private let syntaxParser: SyntaxParser
    
    // keep track of any request's edits, in case a new request is made before completion
    private var editedRangeSinceLastParsing: NSRange? = nil
    private var changeInLengthSinceLastParsing: Int? = nil
    
    //TODO: get font from settings
    private let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.white)
    
    //MARK: - Constructors
    init(syntaxParser: SyntaxParser) {
        
        self.syntaxParser = syntaxParser
    }
    
    // MARK: - methods
    func highlight(editedRange: NSRange, changeInLength: Int, string: NSMutableAttributedString, workItem: DispatchWorkItem, completion: ((_ invalidRanges: [NSRange])->())? = nil) {
        
        self.editedRangeSinceLastParsing = self.editedRangeSinceLastParsing?.union(editedRange) ?? editedRange
        self.changeInLengthSinceLastParsing = (self.changeInLengthSinceLastParsing ?? 0) + changeInLength
    
        guard let editedRange = self.editedRangeSinceLastParsing,
              let changeInLength = self.changeInLengthSinceLastParsing,
              let attributeOccurrences = self.syntaxParser.newAttributeOccurrences(for: string.string, range: string.string.maxNSRange, editedRange: editedRange, changeInLength: changeInLength, workItem: workItem) else {
                return
        }
    
        let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
        let invalidAttributeRanges = attributeOccurrences.invalidRanges
    
        self.editedRangeSinceLastParsing = nil
        self.changeInLengthSinceLastParsing = nil
    
        self.addAttributes(string: string, invalidAttributeRanges: invalidAttributeRanges, newAttributeOccurrences: newAttributeOccurrences)
    
        let invalidRanges = self.invalidRanges(newAttributeOccurrences: newAttributeOccurrences, invalidAttributeRanges: invalidAttributeRanges)
        
        completion?(invalidRanges)
    }
    
    private func addAttributes(string: NSMutableAttributedString, invalidAttributeRanges: [NSRange], newAttributeOccurrences: [AttributeOccurrence]) {
        
        self.delegate?.ignoreProcessing(ignore: true)
        for invalidAttributeRange in invalidAttributeRanges {
            
            guard invalidAttributeRange.location + invalidAttributeRange.length <= string.string.count else {
                
                print("ERROR: attribute range is invalid")
                continue
            }
            
            string.addAttribute(self.normalColorAttribute.key, value: self.normalColorAttribute.value, range: invalidAttributeRange)
        }
        
        for attributeOccurence in newAttributeOccurrences {
            
            string.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
        }
        self.delegate?.ignoreProcessing(ignore: false)
    }
    
    private func invalidRanges(newAttributeOccurrences: [AttributeOccurrence], invalidAttributeRanges: [NSRange]) -> [NSRange] {
        
        let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
            return attributeOccurence.effectiveRange
        })
        
        let invalidRanges = invalidAttributeRanges + newAttributesRanges
        
        return invalidRanges
    }
}
