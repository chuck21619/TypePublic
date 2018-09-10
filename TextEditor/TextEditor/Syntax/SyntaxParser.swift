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
    func attributeOccurrences(for string: String, range: NSRange, editedRange: NSRange, changeInLength: Int) -> (newAttributeOccurrences: [AttributeOccurrence], invalidRanges: [NSRange])? {
        
        // i dont know why editedRange does not include the change in length
        // ^ i dont think this is always true. when highlighting a selection and pasting. the actual editedRange only includes the highlightedRange, while the editedRange includes all the pasted characters
        // ^ i am probly confused about what changeInLength means
        // TODO: fix this^ (and below where i am appending the new characters to invalidRanges)
        let actualEditedRange = NSRange(location: editedRange.location, length: changeInLength)
        
        guard let allAttributeOccurrences = language.attributes(for: string, range: range) else {
            return nil
        }
        
        //FIXME: the equal sign to create a h1 title - the editedRange does not include the attributeRange
        //^ until this is fixed. the regex has been changed to include the equal signs
        let newAttributeOccurrences = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in
            // TODO: refer to earlier comments regarding actualEditedRange and editedRange
            attributeOccurrence.intersects(range: actualEditedRange) || attributeOccurrence.intersects(range: editedRange)
        }
        
        let invalidAttributeOccurences = lastAttributeOccurrences.filter { (attributeOccurence) -> Bool in
            return attributeOccurence.intersects(range: actualEditedRange)
        }
        var invalidRanges = invalidAttributeOccurences.map { (attributeOccurrence) -> NSRange in
            
            let attributeRange = attributeOccurrence.range
            let location = attributeRange.location
            let length = attributeRange.length + changeInLength
            let range = NSRange(location: location, length: length)
            let positiveRange = range.positive

            return positiveRange
        }
        
        // always invalidate new characters
        // FIXME: see above comments regarding actualEditedRange
        let newCharacterRange = actualEditedRange
        if newCharacterRange.length > 0 {
            invalidRanges.append(newCharacterRange)
        }
        
        let alsoNewCharacterRange = editedRange
        if alsoNewCharacterRange.length > 0 {
            invalidRanges.append(editedRange)
        }
        
        
        self.lastAttributeOccurrences = allAttributeOccurrences
        
        return (newAttributeOccurrences: newAttributeOccurrences, invalidRanges: invalidRanges)
    }
    
    func attributes(at location: Int, for string: String) -> [NSAttributedStringKey : Any]? {
        
        let range = string.maxNSRange
        
        guard let allAttributeOccurrences = language.attributes(for: string, range: range) else {
            return nil
        }
        
        let occurrencesForLocation = allAttributeOccurrences.filter { (attributeOccurrence) -> Bool in

            let includesLocation = attributeOccurrence.intersects(location: location)
            return includesLocation
        }
        
        var dictionary: [NSAttributedStringKey:Any] = [:]
        for attributeOccurrence in occurrencesForLocation {
            let attribute = attributeOccurrence.attribute
            dictionary[attribute.key] = attribute.value
        }
        
        return dictionary
    }
}
