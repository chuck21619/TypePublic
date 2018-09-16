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
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int) -> (allAttributeOccurrences: [AttributeOccurrence], newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange])? {
        
        // i dont know why editedRange does not include the change in length
        // ^ i dont think this is always true. when highlighting a selection and pasting. the actual editedRange only includes the highlightedRange, while the editedRange includes all the pasted characters
        // ^ i am probly confused about what changeInLength means
        // TODO: fix this^ (and below where i am appending the new characters to invalidRanges)
        let actualEditedRange = NSRange(location: editedRange.location, length: changeInLength)
        
        guard let allAttributeOccurrences = language.attributes(for: string, range: range) else {
            return nil
        }
        
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            // TODO: cleanup
//            let attributeIsBeforeInsertionPoint = attributeOccurrence.effectiveRange.location < actualEditedRange.location
            
            // maybe this is calculating the range AFTER the change in length?
            let locationNotSureChangeInLength: Int
            let lengthNotSureChangeInLength: Int
            
//            if attributeIsBeforeInsertionPoint {
//                locationNotSureChangeInLength = actualEditedRange.location - changeInLength
//                lengthNotSureChangeInLength = actualEditedRange.length - changeInLength
//            }
//            else {
                locationNotSureChangeInLength = actualEditedRange.location + changeInLength
                lengthNotSureChangeInLength = actualEditedRange.length + changeInLength
//            }
            let rangeNotSureChangeInLength = NSRange(location: locationNotSureChangeInLength, length: lengthNotSureChangeInLength)
            
            
            return attributeOccurrence.intersects(range: rangeNotSureChangeInLength) || attributeOccurrence.intersects(range: editedRange)
        }
        
        let invalidAttributeOccurences = lastAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            
            return attributeOccurrence.intersects(range: editedRange)
        }
        
        var invalidRanges = invalidAttributeOccurences.map { (attributeOccurrence) -> NSRange in
            
            let effectiveRange = attributeOccurrence.effectiveRange
            let location = effectiveRange.location
            let length = effectiveRange.length + changeInLength
            let range = NSRange(location: location, length: max(0,length))
            
            return range
        }
        
        // always invalidate new characters
        // TODO: clean up
        let newCharacterRange = actualEditedRange
        if newCharacterRange.length > 0 {
            invalidRanges.append(newCharacterRange)
        }
        
        let alsoNewCharacterRange = editedRange
        if alsoNewCharacterRange.length > 0 {
            invalidRanges.append(editedRange)
        }
        
        return (allAttributeOccurrences: allAttributeOccurrences, newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
}
