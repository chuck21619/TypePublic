//
//  MarkdownFactory.swift
//  TextEditor
//
//  Created by charles johnston on 8/28/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class MarkdownFactory {
    
    // MARK: properties
    let headerTitleAttributeKey = NSAttributedString.Key.foregroundColor
    let headerTitleColor = NSColor.brown
    
    // MARK: methods
    func createMarkdown() -> Language {
        
        let keywords = createKeywords()
        let textGroupingRules = createTextGroupingRules()
        let language = Language(name: "Markdown", definedLanguage: .Markdown, keywords: keywords, textGroupingRules: textGroupingRules)
        return language
    }
    
    // MARK: - Keywords
    func createKeywords() -> [Keyword] {
        
        // TODO: get fonts from settings. and dont do force unwrapping
        let italicFont = NSFont(name: "Menlo-Italic", size: 11)!
        let boldFont = NSFont(name: "Menlo-Bold", size: 11)!
        
        let keywords = [            
            // #h1 titles, ##h2 titles,  etc.
            createKeyword("(^|\\n)\\s*#+(?![^\\s])", headerTitleAttributeKey, headerTitleColor),
            
            // TODO: fix italic font issue. type the following line in the editor to see the problem:
            //  * apples * awef* oranges
            
            // _italic font_ *italic font*
            createKeyword("(_|\\*).+\\1", .font, italicFont),
            
            // **bold font** __bold font__
            createKeyword("(__|\\*\\*).+\\1", .font, boldFont),
            
            // `monospace font` belongs in backticks
            createKeyword("\\`.+\\`", .foregroundColor, NSColor.systemBlue),
            
            // *** horizontal rule // can use *** or --- or ___
            createKeyword("(^|\\n)\\s*(---+|___+|\\*\\*\\*+)\\s*(?=\\n)", .foregroundColor, NSColor.magenta),
            
            // + unordered list items // can use * or - or +
            createKeyword("(^|\\n)\\s*\\* |- |\\+ ", .foregroundColor, NSColor.orange),
            
            // 1. list items
            createKeyword("(^|\\n)\\s*[0-9]\\. ", .foregroundColor, NSColor.red),
            
            // [link title](www.linkAddress.com)
            createLinksKeyword(),
            
            // one or more equal signs denotes the text above it is an H1 title
            createH1EqualSignsKeyword(),
            
            // > block quotes are preceded by '>'
            createKeyword("(^|\\n)\\s*>(.|\\n)*?(?=\\n\\n|$)", .foregroundColor, NSColor.systemGray),
 
        ]
        
        return keywords
    }
    
    func createKeyword( _ regexPattern: String, _ attributeKey: NSAttributedString.Key, _ attributeValue: Any) -> Keyword {
        
        let attribute = Attribute(key: attributeKey, value: attributeValue)
        let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
        
        return keyword
    }
    // MARK: special keyword cases
    
    // Links //[link title](www.linkAddress.com)
    func createLinksKeyword() -> Keyword {
        
        let linkTitleKeywordRegexLabel = "linkTitle"
        let linkAddressKeywordRegexLabel = "linkAddress"
        
        let linksRegexPattern = "(?<\(linkTitleKeywordRegexLabel)>\\[(?=[^\\(\\)\\[\\]]*\\]\\().*?\\])(?<\(linkAddressKeywordRegexLabel)>\\(.*?\\))"
        
        let linksAttributeOccurrencesProvider = CustomAttributeOccurrencesProvider { (match) -> [AttributeOccurrence] in
            
            var attributeOccurences: [AttributeOccurrence] = []
            
            let titleAttribute = Attribute(key: .foregroundColor, value: NSColor.systemGreen)
            let titleRange = match.range(withName: linkTitleKeywordRegexLabel)
            let titleAttributeOccurrence = AttributeOccurrence(attribute: titleAttribute, attributeRange: titleRange, effectiveRange: match.range)
            attributeOccurences.append(titleAttributeOccurrence)
            
            let addressAttribute = Attribute(key: .foregroundColor, value: NSColor.systemYellow)
            let addressRange = match.range(withName: linkAddressKeywordRegexLabel)
            let addressAttributeOccurrence = AttributeOccurrence(attribute: addressAttribute, attributeRange: addressRange, effectiveRange: match.range)
            attributeOccurences.append(addressAttributeOccurrence)
            
            return attributeOccurences
        }
        
        let linksKeyword = Keyword(regexPattern: linksRegexPattern, attributeOccurencesProvider: linksAttributeOccurrencesProvider)
        
        return linksKeyword
    }
    
    // 1 or more equal signs denotes the text above it is an H1 title
    func createH1EqualSignsKeyword() -> Keyword {

        let titleGroup = "titleGroup"
        let regexPattern = "(?<\(titleGroup)>(^|\\n)\\s*.+)(\\n\\s*=+\\s*(\\n|$))"
        let provider = CustomAttributeOccurrencesProvider { (match) -> [AttributeOccurrence] in
            
            let attribute = Attribute(key: self.headerTitleAttributeKey, value: self.headerTitleColor)
            let titleRange = match.range(withName: titleGroup)
            let occurrence = AttributeOccurrence(attribute: attribute, attributeRange: titleRange, effectiveRange: match.range)
            
            return [occurrence]
        }
        
        let keyword = Keyword(regexPattern: regexPattern, attributeOccurencesProvider: provider)
        
        return keyword
    }
    
    // MARK: - Text Groups
    func createTextGroupingRules() -> [TextGroupingRule] {
        
        let labelGroupTitle = "labelGroupTitle"
        
        let rule1 = TextGroupingRule(regexPattern: "(^|\\n)\\s*#(?![^\\s])\\s*(?<\(labelGroupTitle)>.*)(?=\\n|$)", labelGroupTitle: labelGroupTitle)
        let rule2 = TextGroupingRule(regexPattern: "(^|\\n)\\s*##(?![^\\s])\\s*(?<\(labelGroupTitle)>.*)(?=\\n|$)", labelGroupTitle: labelGroupTitle)
        let rule3 = TextGroupingRule(regexPattern: "(^|\\n)\\s*###(?![^\\s])\\s*(?<\(labelGroupTitle)>.*)(?=\\n|$)", labelGroupTitle: labelGroupTitle)
        return [rule1, rule2, rule3]
    }
}
