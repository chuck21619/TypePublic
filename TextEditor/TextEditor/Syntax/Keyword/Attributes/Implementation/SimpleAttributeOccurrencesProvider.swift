//
//  SimpleAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SimpleAttributeOccurrencesProvider: AttributeOccurrencesProvider {
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, range: NSRange) -> [AttributeOccurrence] {
        
        guard let attribute = keyword.attribute else {
            // if the keyword was not initialized with an attribute, then the simple provider should not do anything, as it should not predict any attribute changes (maybe a default attribute should be used?)
            return []
        }
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        let regexString = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexString) else {
            return []
        }
        
        guard string.contains(range: range) else {
            
            return []
        }
        
        regex.enumerateMatches(in: string, range: range) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeOccurence = AttributeOccurrence(attribute: attribute, range: match.range)
            attributeOccurences.append(attributeOccurence)
        }
        
        return attributeOccurences
    }
}
