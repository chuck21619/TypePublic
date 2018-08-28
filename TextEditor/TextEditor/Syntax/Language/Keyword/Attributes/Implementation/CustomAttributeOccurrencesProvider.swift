//
//  BettCAAP.swift
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
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeOccurrence] {
        
        var attributeApplications: [AttributeOccurrence] = []
        
        let regexStr = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexStr) else {
            return []
        }
        
        regex.enumerateMatches(in: string, range: changedRange) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeApplication = enumerator(match)
            attributeApplications.append(contentsOf: attributeApplication)
        }
        
        return attributeApplications
    }
}
