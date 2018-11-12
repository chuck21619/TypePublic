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
                
                var tokenAmount = 0
                if let indeterminateGroupingRuleProperties = groupingRule.indeterminateGroupingRuleProperties {
                    
                    guard let indeterminateRange = Range(match.range(withName: indeterminateGroupingRuleProperties.indeterminateGroupLabel), in: string) else {
                        return
                    }
                    
                    let indeterminateString = String(string[indeterminateRange])
                    tokenAmount = indeterminateString.count
                }
                
                let tokenRange = match.range(withName: groupingRule.trimmedGroupTitle)
                
                let token = TextGroupToken(label: label, range: tokenRange, groupingRule: groupingRule, tokenAmount: tokenAmount)
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
    
    // MARK: - Grouping Priority
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
    
    // TODO: change these into equatable. i think i would have to add the language as a property on the token object
    func priority(of firstTextGroupToken: TextGroupToken, isHigherThan secondTextGroupToken: TextGroupToken) -> Bool {
        
        guard let firstRuleIndex = index(of: firstTextGroupToken.groupingRule), let secondRuleIndex = index(of: secondTextGroupToken.groupingRule) else {
            return false
        }
        
        // when tokens are associated with the same rule, and the rule is ideterminate - compare token amount
        if firstRuleIndex == secondRuleIndex, let indeterminateGroupingRuleProperties = firstTextGroupToken.groupingRule.indeterminateGroupingRuleProperties {
            
            let ascending = indeterminateGroupingRuleProperties.ascending
            
            if ascending {
                
                return firstTextGroupToken.tokenAmount < secondTextGroupToken.tokenAmount
            }
            else {
                
                return secondTextGroupToken.tokenAmount < firstTextGroupToken.tokenAmount
            }
            
        }
        else {
            
            // a lower index means higher priority
            return firstRuleIndex < secondRuleIndex
        }
    }
    
    func priority(of firstTextGroupToken: TextGroupToken, isEqualTo secondTextGroupToken: TextGroupToken) -> Bool {
        
        guard let firstRuleIndex = index(of: firstTextGroupToken.groupingRule), let secondRuleIndex = index(of: secondTextGroupToken.groupingRule) else {
            return false
        }
        
        // a lower index means higher priority
        return firstRuleIndex == secondRuleIndex
    }
}
