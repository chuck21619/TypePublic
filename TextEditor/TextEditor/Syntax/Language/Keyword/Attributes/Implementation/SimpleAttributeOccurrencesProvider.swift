//
//  SimpleAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SimpleAttributeOccurrencesProvider: AttributeOccurrencesProvider {
    
    // MARK: properties
    var searchAllText: Bool
    
    // MARK: Constructors
    init(searchAllText: Bool = false) {
        
        self.searchAllText = searchAllText
    }
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeOccurrence] {
        
        guard let attribute = keyword.attribute else {
            // if the keyword was not initialized with an attribute, then the simple provider should not do anything, as it should not predict any attribute changes (maybe a default attribute should be used?)
            return []
        }
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        let regexStr = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexStr) else {
            return []
        }
        
        let searchRange = rangeToEnumerate(string: string, changedRange: changedRange)
        
        regex.enumerateMatches(in: string, range: searchRange) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeOccurence = AttributeOccurrence(attribute: attribute, range: match.range)
            attributeOccurences.append(attributeOccurence)
        }
        
        return attributeOccurences
    }
    
    private func rangeToEnumerate(string: String, changedRange: NSRange) -> NSRange {
        
        let rangeToEnumerate: NSRange
        if searchAllText {
            
            rangeToEnumerate = NSRange(string.startIndex.encodedOffset ..< string.endIndex.encodedOffset)
        }
        else {
            
            rangeToEnumerate = changedRange
        }
        
        return rangeToEnumerate
    }
}
