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
    
    func attributes(for string: String, range: NSRange, workItem: DispatchWorkItem) -> [AttributeOccurrence]? {
        
        var attributeOccurences: [AttributeOccurrence] = []
        
        for keyword in keywords {
            
            let attributeOccurencesProvider = keyword.attributeOccurencesProvider
            let attributeOccurencesToAppend = attributeOccurencesProvider.attributes(for: keyword, in: string, range: range, workItem: workItem)
            attributeOccurences.append(contentsOf: attributeOccurencesToAppend)
            
            guard workItem.isCancelled == false else {
                return nil
            }
        }
        
        return attributeOccurences
    }
    
    func textGroupsHierarchy() -> [Int:TextGroup] {
        
        //TODO: LAST LEFT OFF
        
        return [:]
    }
}
