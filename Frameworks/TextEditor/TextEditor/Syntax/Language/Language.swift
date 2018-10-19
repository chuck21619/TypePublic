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
    
    //textGroupingRules is an ordered list of rules on how to represent the document in an outline view
    let textGroupingRules: [TextGroupingRule]
    
    init(name: String, definedLanguage: DefinedLanguage, keywords: [Keyword], textGroupingRules: [TextGroupingRule]) {
        
        self.name = name
        self.definedLanguage = definedLanguage
        self.keywords = keywords
        self.textGroupingRules = textGroupingRules
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
    
    func textGroupTokens(for string: String, workItem: DispatchWorkItem) -> [TextGroupToken]? {
        
        var tokens: [TextGroupToken] = []
        
        let range = string.maxNSRange
        
        for groupingRule in textGroupingRules {
            
            let regexString = groupingRule.regexPattern
            
            guard let regex = try? NSRegularExpression(pattern: regexString) else {
                return nil
            }
            
            regex.enumerateMatches(in: string, range: range) { (match, flags, stop) in
                
                guard let match = match else {
                    return
                }
                
                guard let range = Range(match.range, in: string) else {
                    return
                }
                
                let matchedString = String(string[range])
                let token = TextGroupToken(string: matchedString, range: match.range)
                tokens.append(token)
                
                guard workItem.isCancelled == false else {
                    return
                }
            }
            
            guard workItem.isCancelled == false else {
                return nil
            }
        }
        
        return tokens
    }
}
