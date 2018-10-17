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
    let textGroupsHierarchy: ([AttributeOccurrence])->([TextGroup])
    
    init(name: String, definedLanguage: DefinedLanguage, keywords: [Keyword], textGroupsHierarchy: @escaping ([AttributeOccurrence])->([TextGroup])) {
        
        self.name = name
        self.definedLanguage = definedLanguage
        self.keywords = keywords
        self.textGroupsHierarchy = textGroupsHierarchy
    }
    
    func attributes(for string: String, workItem: DispatchWorkItem) -> [AttributeOccurrence]? {
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        for keyword in keywords {
            
            let attributeOccurencesProvider = keyword.attributeOccurencesProvider
            let attributeOccurencesToAppend = attributeOccurencesProvider.attributes(for: keyword, in: string, workItem: workItem)
            attributeOccurences.append(contentsOf: attributeOccurencesToAppend)
            
            guard workItem.isCancelled == false else {
                return nil
            }
        }
        
        return attributeOccurences
    }
}
