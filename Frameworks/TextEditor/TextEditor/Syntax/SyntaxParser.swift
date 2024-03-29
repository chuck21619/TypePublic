//
//  SyntaxParser.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SyntaxParser {
    
    // MARK: - Properties
    var language: Language
    var lastAttributeOccurrences: [AttributeOccurrence] = []
    
    // MARK: - Constructors    
    init(language: Language) {
        self.language = language
    }
    
    // MARK: - Methods    
    func newAttributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int, workItem: DispatchWorkItem) -> (newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange])? {
        
        guard let allAttributeOccurrences = language.attributes(for: string, workItem: workItem) else {
            return nil
        }
        
        guard workItem.isCancelled == false else {
            return nil
        }
        
        let invalidRanges = calcInvalidRanges(editedRange: editedRange, changeInLength: changeInLength)

        let newAttributeOccurrences = calcNewAttributeOccurrences(allAttributeOccurrences: allAttributeOccurrences, editedRange: editedRange, invalidRanges: invalidRanges)
        
        self.lastAttributeOccurrences = allAttributeOccurrences
        
        
        return (newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
    
    private func calcNewAttributeOccurrences(allAttributeOccurrences: [AttributeOccurrence], editedRange: NSRange, invalidRanges: [NSRange]) -> [AttributeOccurrence] {
        
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            
            let attributeOccurrenceIntersectsEditedRange = attributeOccurrence.intersects(range: editedRange)
            let attributeOccurrenceIsAdjacentToEditedRange = attributeOccurrence.isAdjacent(to: editedRange)
            
            var attributeOccurrenceIntersectsInvalidatedRange = false
            for invalidRange in invalidRanges {
                
                if attributeOccurrence.intersects(range: invalidRange) {
                    attributeOccurrenceIntersectsInvalidatedRange = true
                    break
                }
            }
            
            let attributeIsAffectedByEdit = attributeOccurrenceIntersectsEditedRange || attributeOccurrenceIsAdjacentToEditedRange || attributeOccurrenceIntersectsInvalidatedRange
            
            return attributeIsAffectedByEdit
        }
        
        return newAttributeOccurrences
    }
    
    private func calcInvalidRanges(editedRange: NSRange, changeInLength: Int) -> [NSRange] {
        
        var invalidRanges = lastAttributeOccurrences.compactMap { (attributeOccurrence) -> NSRange? in
            
            guard let attributeOccurrenceRangeAfterEdit = attributeOccurrence.effectiveRangeAfterEdit(editedRange: editedRange, changeInLength: changeInLength) else {
                
                return nil
            }
            
            let attributeOccurrenceIntersectsEditedRange = attributeOccurrenceRangeAfterEdit.intersects(editedRange)
            let attributeOccurrenceIsAdjacentToEditedRange = attributeOccurrenceRangeAfterEdit.isAdjacent(to: editedRange)
            
            let isInvalid = attributeOccurrenceIntersectsEditedRange || attributeOccurrenceIsAdjacentToEditedRange
            
            guard isInvalid else {
                return nil
            }
            
            return attributeOccurrenceRangeAfterEdit
        }
        
        // always invalidate new characters
        if editedRange.length > 0 {
            invalidRanges.append(editedRange)
        }
        
        return invalidRanges
    }
}
