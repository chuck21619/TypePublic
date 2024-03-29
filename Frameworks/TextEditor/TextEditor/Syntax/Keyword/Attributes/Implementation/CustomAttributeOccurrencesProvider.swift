//
//  CustomAttributeOccurrencesProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/28/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class CustomAttributeOccurrencesProvider: AttributeOccurrencesProvider {
    
    // MARK: Properties
    var enumerator: (NSTextCheckingResult)->[AttributeOccurrence]
    
    // MARK: Constructors
    init(enumerator: @escaping (NSTextCheckingResult)->[AttributeOccurrence]) {
        
        self.enumerator = enumerator
    }
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, workItem: DispatchWorkItem) -> [AttributeOccurrence] {
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        let regexStr = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexStr) else {
            return []
        }
        
        let range = string.maxNSRange
        
        regex.enumerateMatches(in: string, range: range) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeOccurence = enumerator(match)
            attributeOccurences.append(contentsOf: attributeOccurence)
            
            guard workItem.isCancelled == false else {
                return
            }
        }
        
        return attributeOccurences
    }
}
