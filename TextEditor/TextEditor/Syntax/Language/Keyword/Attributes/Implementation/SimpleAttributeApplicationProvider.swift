//
//  SimpleAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SimpleAttributeApplicationProvider: AttributeApplicationProvider {
    
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
            
            let attributeApplication = AttributeApplication(attribute: keyword.attribute, range: match.range)
            attributeApplications.append(attributeApplication)
        }
        
        return attributeApplications
    }
}
