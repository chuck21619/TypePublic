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
    
    // all text group tokens, ordered by range
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
                var label = matchedString
                if let labelRange = Range(match.range(withName: groupingRule.labelGroupTitle), in: string) {
                    label = String(string[labelRange])
                }
                
                if let indeterminateProperties = groupingRule.indeterminateProperties {
                    
                    guard let indeterminateRange = Range(match.range(withName: indeterminateProperties.indeterminateGroupLabel), in: string) else {
                        return
                    }
                    
                    let indeterminateString = String(string[indeterminateRange])
                    print(indeterminateString)
                    // calculate amount
                    // pass amount into TextGroupToken
                    // then figure out how to use the amount when comparing two tokens for higher priority
                }
                
                let token = TextGroupToken(label: label, range: match.range, groupingRule: groupingRule)
                tokens.append(token)
                
                guard workItem.isCancelled == false else {
                    return
                }
            }
            
            guard workItem.isCancelled == false else {
                return nil
            }
        }
        
        //order tokens by range
        let orderedTokens = tokens.sorted { (token1, token2) -> Bool in
            
            return token1.range.location < token2.range.location
        }
        
        return orderedTokens
    }
    
    private func index(of textGroupingRule: TextGroupingRule) -> Int? {
        
        guard let index = textGroupingRules.firstIndex(of: textGroupingRule) else {
            return nil
        }
        
        return index
    }
    
    private func index(of textGroupToken: TextGroupToken) -> Int? {
        
        let rule = textGroupToken.groupingRule
        return index(of: rule)
    }
    
    private func index(of textGroup: TextGroup) -> Int? {
    
        guard let token = textGroup.token else {
            return nil
        }
        
        return index(of: token)
    }
    
    func priority(of firstGroupingRule: TextGroupingRule, isHigherThan secondGroupingRule: TextGroupingRule) -> Bool {
        
        guard let firstRuleIndex = index(of: firstGroupingRule), let secondRuleIndex = index(of: secondGroupingRule) else {
            return false
        }
        
        // a lower index means higher priority
        return firstRuleIndex < secondRuleIndex
    }
}
