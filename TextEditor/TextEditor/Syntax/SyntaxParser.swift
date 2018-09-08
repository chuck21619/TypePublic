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
    // TODO: rename method - it only returns new attributes occurrences and ranges to invalidate
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int) -> (newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange]) {
        
        
        // i dont know why editedRange does not include the change in length
        let actualEditedRange = NSRange(location: editedRange.location, length: changeInLength)
        
        
        let allAttributeOccurrences = language.attributes(for: string, changedRange: range)
        
        //FIXME: the equal sign to create a h1 title - the editedRange does not include the attributeRange
        //^ until this is fixed. the regex has been changed to include the equal signs
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            attributeOccurrence.intersects(range: actualEditedRange)
        }
        
        
        
        let invalidAttributeOccurences = lastAttributeOccurrences.filter { (attributeOccurence) -> Bool in
            return attributeOccurence.intersects(range: actualEditedRange)
        }
        var invalidRanges = invalidAttributeOccurences.map { (attributeOccurrence) -> NSRange in
            
            let attributeRange = attributeOccurrence.range
            let invalidRangeLength = attributeRange.length + changeInLength
            let invalidRange = NSRange(location: attributeRange.location, length: invalidRangeLength)
            
            return invalidRange
        }
        
        //TODO: always invalidate the insertion point so new characters will be standard
        let insertionPointRange = NSRange(location: editedRange.location, length: 0)
        invalidRanges.append(insertionPointRange)
        
        self.lastAttributeOccurrences = allAttributeOccurrences
        
        
        return (newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
}
