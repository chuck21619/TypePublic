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
    func attributes(for keyword: Keyword, in string: String, workItem: DispatchWorkItem) -> [AttributeOccurrence] {
        
        guard let attribute = keyword.attribute else {
            return []
        }
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        let regexString = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexString) else {
            return []
        }
        
        let range = string.maxNSRange
        
        regex.enumerateMatches(in: string, range: range) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeOccurence = AttributeOccurrence(attribute: attribute, attributeRange: match.range)
            attributeOccurences.append(attributeOccurence)
            
            guard workItem.isCancelled == false else {
                return
            }
        }
        
        return attributeOccurences
    }
}
