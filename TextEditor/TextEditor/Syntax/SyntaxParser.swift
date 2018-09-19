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
    convenience init() {
        let languageFactory = LanguageFactory()
        let language = languageFactory.createLanguage(LanguageFactory.defaultLanguage)
        self.init(language: language)
    }
    
    init(language: Language) {
        self.language = language
    }
    
    // MARK: - Methods
    // TODO: rename method - it only returns NEW attributes occurrences and ranges to invalidate
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int) -> (allAttributeOccurrences: [AttributeOccurrence], newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange])? {
        
        guard let allAttributeOccurrences = language.attributes(for: string, range: range) else {
            return nil
        }
        
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            
            //check if i also need to append any attributes that intersect invalidated ranges
            
            
            
            return attributeOccurrence.intersects(range: editedRange)
        }
        
        let invalidAttributeOccurences = lastAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            
            guard let attributeOccurrenceRangeAfterEdit = calcAttributeRangeAfterEdit(attributeOccurrence: attributeOccurrence, editedRange: editedRange, changeInLength: changeInLength) else {
                
                return false
            }
            
            let attributeOccurrenceIntersectsEditedRange = attributeOccurrenceRangeAfterEdit.intersects(editedRange)
            let attributeOccurrenceIsAdjacentToEditedRange = attributeOccurrenceRangeAfterEdit.isAdjacent(to: editedRange)
            
            let isInvalid = attributeOccurrenceIntersectsEditedRange || attributeOccurrenceIsAdjacentToEditedRange
            
            return isInvalid
        }
        
        var invalidRanges = invalidAttributeOccurences.map { (attributeOccurrence) -> NSRange in
            
            return calcAttributeRangeAfterEdit(attributeOccurrence: attributeOccurrence, editedRange: editedRange, changeInLength: changeInLength) ?? NSRange(location: 0, length: 0)
        }
        
        // always invalidate new characters
        if editedRange.length > 0 {
            invalidRanges.append(editedRange)
        }
        
        return (allAttributeOccurrences: allAttributeOccurrences, newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
    
    func calcAttributeRangeAfterEdit(attributeOccurrence: AttributeOccurrence, editedRange: NSRange, changeInLength: Int) -> NSRange? {

        let range: NSRange?
        
        //TODO: think about when characters are replaced
//        if changeInLength == 0 {
//
//            range = nil
//
//        }
            //Deleting Characters
        if changeInLength < 0 {
            
            if editedRange.location < attributeOccurrence.effectiveRange.location {
                
                //1
                if editedRange.location - changeInLength < attributeOccurrence.effectiveRange.location + attributeOccurrence.effectiveRange.length {
                    
                    let location = editedRange.location
                    let overlap = (editedRange.location - changeInLength) - attributeOccurrence.effectiveRange.location
                    let length = attributeOccurrence.effectiveRange.length - max(overlap, 0)
                    
                    range = NSRange(location: location, length: length)
                }
                //4
                else {
                    
                    range = nil
                }
                
            }
            else  {
                
                //2
                if editedRange.location - changeInLength > attributeOccurrence.effectiveRange.location + attributeOccurrence.effectiveRange.length {
                    
                    let location = attributeOccurrence.effectiveRange.location
                    let overlap = (attributeOccurrence.effectiveRange.location + attributeOccurrence.effectiveRange.length) - editedRange.location
                    let length = attributeOccurrence.effectiveRange.length - max(0, overlap)
                    
                    range = NSRange(location: location, length: length)
                }
                //3
                else {
                    
                    let location = attributeOccurrence.effectiveRange.location
                    let length = attributeOccurrence.effectiveRange.length + changeInLength
                    
                    range = NSRange(location: location, length: length)
                }
            }
        }
        
            // Adding characters
        else {
            
            //6
            if editedRange.location <= attributeOccurrence.effectiveRange.location {
                
                let location = attributeOccurrence.effectiveRange.location + changeInLength
                let length = attributeOccurrence.effectiveRange.length
                
                range = NSRange(location: location, length: length)
            }
            else {

                //7
                if editedRange.location > attributeOccurrence.effectiveRange.location && editedRange.location < attributeOccurrence.effectiveRange.location + attributeOccurrence.effectiveRange.length {
                    
                    let location = attributeOccurrence.effectiveRange.location
                    let length = attributeOccurrence.effectiveRange.length + changeInLength
                    
                    range = NSRange(location: location, length: length)
                    
                }
                //8
                else {
                    
                    range = attributeOccurrence.effectiveRange
                }
            }
        }
        
        
        return range
        
        
        
        
        
        
        
//        if attributeOccurrence.effectiveRange.location > editedRange.location {
//
//            return NSRange(location: attributeOccurrence.effectiveRange.location + changeInLength, length: attributeOccurrence.effectiveRange.length)
//        }
//
//        return attributeOccurrence.effectiveRange
    }
}
