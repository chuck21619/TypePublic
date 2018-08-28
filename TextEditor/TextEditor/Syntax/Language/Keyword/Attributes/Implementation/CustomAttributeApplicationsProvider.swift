//
//  BettCAAP.swift
//  TextEditor
//
//  Created by charles johnston on 8/28/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class CustomAttributeApplicationsProvider: AttributeApplicationsProvider {
    
    // MARK: Properties
    var enumerator: (NSTextCheckingResult)->[AttributeApplication]
    
    // MARK: Constructors
    init(enumerator: @escaping (NSTextCheckingResult)->[AttributeApplication]) {
        
        self.enumerator = enumerator
    }
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeApplication] {
        
        var attributeApplications: [AttributeApplication] = []
        
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
