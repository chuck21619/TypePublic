//
//  Language.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class Language {
    
    let name: String
    let definedLanguage: DefinedLanguage
    let keywords: [Keyword]
    
    init(name: String, definedLanguage: DefinedLanguage, keywords: [Keyword]) {
        
        self.name = name
        self.definedLanguage = definedLanguage
        self.keywords = keywords
    }
    
    func attributes(for string: String, changedRange: NSRange) -> [AttributeApplication] {
        
        var attributeApplications: [AttributeApplication] = []
        
        for keyword in keywords {
            
            let attributeApplicationsProvider = keyword.attributeApplicationsProvider
            let attributeApplicationsToAppend = attributeApplicationsProvider.attributes(for: keyword, in: string, changedRange: changedRange)
            attributeApplications.append(contentsOf: attributeApplicationsToAppend)
        }
        
        return attributeApplications
    }
}
