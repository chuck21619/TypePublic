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
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int) -> (newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange]) {
        
        
        // i dont know why editedRange does not include the change in length
        let actualEditedRange = NSRange(location: editedRange.location, length: changeInLength)
        
        
        let allAttributeOccurrences = language.attributes(for: string, changedRange: range)
        
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            attributeOccurrence.intersects(range: actualEditedRange)
        }
        
        
        
        let invalidAttributeOccurences = lastAttributeOccurrences.filter { (attributeOccurence) -> Bool in
            return attributeOccurence.intersects(range: actualEditedRange)
        }
        let invalidRanges = invalidAttributeOccurences.map { (attributeOccurrence) -> NSRange in
            return attributeOccurrence.range
        }
        
        self.lastAttributeOccurrences = allAttributeOccurrences
        
        
        return (newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
}
