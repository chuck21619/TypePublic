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
    fileprivate func attributeRangeIncludesEditedRange(_ rangeIntersection: NSRange?, _ editedRange: NSRange, _ attributeOccurrenceRange: NSRange) -> Bool {
        return (rangeIntersection?.length ?? 0) > 0 || NSLocationInRange(editedRange.location, attributeOccurrenceRange)
    }
    
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange) -> (newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange]) {
        
        // append to invalidRanges, all attribute occurrence ranges that include the editedRange
        // as well as remove those ranges from the lastAttributeOccurences (so any new/existing attributes that are still valid will be appended to the newAttributeOccurrences)
        var invalidRanges: [NSRange] = []
        for attributeOccurrence in lastAttributeOccurrences {
            
            let attributeOccurrenceRange = attributeOccurrence.range
            let rangeIntersection = attributeOccurrenceRange.intersection(editedRange)
            let attributeRangeIsInvalid = attributeRangeIncludesEditedRange(rangeIntersection, editedRange, attributeOccurrenceRange)
            
            if attributeRangeIsInvalid {
                
                invalidRanges.append(attributeOccurrenceRange)
                
                if let attributeOccurrenceIndex = lastAttributeOccurrences.index(of: attributeOccurrence) {
                    lastAttributeOccurrences.remove(at: attributeOccurrenceIndex)
                }
            }
        }
        
        let allAttributeOccurrences = language.attributes(for: string, changedRange: range)
        
        // new attribute occurrences to apply
        let newAttributeOccurrences = lastAttributeOccurrences.difference(from: allAttributeOccurrences)
        
        self.lastAttributeOccurrences = allAttributeOccurrences
        
        return (newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
}
