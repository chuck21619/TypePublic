//
//  SimpleAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SimpleAttributeApplicationsProvider: AttributeApplicationsProvider {
    
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeApplication] {
        
        guard let attribute = keyword.attribute else {
            // if the keyword was not initialized with an attribute, then the simple provider should not do anything, as it should not predict any attribute changes (maybe a default attribute should be used?)
            return []
        }
        
        var attributeApplications: [AttributeApplication] = []
        
        let regexStr = keyword.regexPattern
        
        guard let regex = try? NSRegularExpression(pattern: regexStr) else {
            return []
        }
        
        regex.enumerateMatches(in: string, range: changedRange) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let attributeApplication = AttributeApplication(attribute: attribute, range: match.range)
            attributeApplications.append(attributeApplication)
        }
        
        return attributeApplications
    }
}
