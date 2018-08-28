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
    let italicFont = NSFontManager().convert(NSFont.systemFont(ofSize: 11), toHaveTrait: .italicFontMask)
    let boldFont = NSFont.boldSystemFont(ofSize: 11)
    let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
    
    let headerTitleAttributeKey = NSAttributedStringKey.foregroundColor
    let headerTitleColor = NSColor.brown
    
    // MARK: methods
    func createMarkdown() -> Language {
        
        let keywords = createKeywords()
        let language = Language(name: "Markdown", definedLanguage: .Markdown, keywords: keywords)
        return language
    }
    
    // MARK: - Keywords
    func createKeywords() -> [Keyword] {
        
        let italicFont = NSFontManager().convert(NSFont.systemFont(ofSize: 11), toHaveTrait: .italicFontMask)
        let boldFont = NSFont.boldSystemFont(ofSize: 11)
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        
        let keywords = [// #h1 titles, ##h2 titles,  etc.
            createKeyword("^\\s*#+", .foregroundColor, NSColor.brown),
            
            // _italic font_ *italic font*
            createKeyword("(_|\\*)[^_\\*\\n]+\\1", .font, italicFont),
            
            // **bold font** __bold font__
            createKeyword("(__|\\*\\*)[^_\\*\\n]+\\1", .font, boldFont),
            
            // `monospace font` belongs in backticks
            createKeyword("`[^`\\n]+`", .font, monospaceFont),
            
            // *** horizontal rule // can use *** or --- or ___
            createKeyword("^(___+|---+|\\*\\*\\*+)", .foregroundColor, NSColor.magenta),
            
            // + unordered list items // can use * or - or +
            createKeyword("^\\s*(\\* |- |\\+ )", .foregroundColor, NSColor.orange),
            
            // 1. list items
            createKeyword("^\\s*[0-9]\\. ", .foregroundColor, NSColor.red),
            
            // [link title](www.linkAddress.com)
            createLinksKeyword(),
            
            // 3 or more equal signs denotes the text above it is an H1 title
            createH1EqualSignsKeyword()
        ]
        
        return keywords
    }
    
    func createKeyword( _ regexPattern: String, _ attributeKey: NSAttributedStringKey, _ attributeValue: Any) -> Keyword {
        
        let attribute = Attribute(key: attributeKey, value: attributeValue)
        let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
        
        return keyword
    }
    // MARK: special keyword cases
    
    // Links //[link title](www.linkAddress.com)
    func createLinksKeyword() -> Keyword {
        
        let linkTitleKeywordRegexLabel = "linkTitle"
        let linkAddressKeywordRegexLabel = "linkAddress"
        let linksAttributeOccurrencesProvider = CustomAttributeOccurrencesProvider { (match) -> [AttributeOccurrence] in
            
            var attributeOccurences: [AttributeOccurrence] = []
            
            let titleAttribute = Attribute(key: .foregroundColor, value: NSColor.systemGreen)
            let titleRange = match.range(withName: linkTitleKeywordRegexLabel)
            let titleAttributeOccurrence = AttributeOccurrence(attribute: titleAttribute, range: titleRange)
            attributeOccurences.append(titleAttributeOccurrence)
            
            let addressAttribute = Attribute(key: .foregroundColor, value: NSColor.systemYellow)
            let addressRange = match.range(withName: linkAddressKeywordRegexLabel)
            let addressAttributeOccurrence = AttributeOccurrence(attribute: addressAttribute, range: addressRange)
            attributeOccurences.append(addressAttributeOccurrence)
            
            return attributeOccurences
        }
        
        let linksRegexPattern = "(?<\(linkTitleKeywordRegexLabel)>\\[(?=[^\\(\\)\\[\\]]*\\]\\().*?\\])(?<\(linkAddressKeywordRegexLabel)>\\(.*?\\))"
        let linksKeyword = Keyword(regexPattern: linksRegexPattern, attributeOccurencesProvider: linksAttributeOccurrencesProvider)
        
        return linksKeyword
    }
    
    
    // 3 or more equal signs denotes the text above it is an H1 title
    func createH1EqualSignsKeyword() -> Keyword {

        let regexPattern = ".+(?=\\n===+\\n)"
        let provider = SimpleAttributeOccurrencesProvider(searchAllText: true)
        let attribute = Attribute(key: headerTitleAttributeKey, value: headerTitleColor)
        
        let keyword = Keyword(regexPattern: regexPattern, attribute: attribute, attributeOccurencesProvider: provider)
        
        return keyword
    }
}
