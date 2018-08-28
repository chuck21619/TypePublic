//
//  MarkdownFactory.swift
//  TextEditor
//
//  Created by charles johnston on 8/28/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class MarkdownFactory {
    
    func createMarkdown() -> Language {
        
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
            createLinksKeyword()
        ]
        
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
            createLinksKeyword()
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
        let linksAttributeApplicationsProvider = CustomAttributeOccurrencesProvider { (match) -> [AttributeOccurrence] in
            
            var attributeApplications: [AttributeOccurrence] = []
            
            let titleAttribute = Attribute(key: .foregroundColor, value: NSColor.systemGreen)
            let titleRange = match.range(withName: linkTitleKeywordRegexLabel)
            let titleAttributeApplication = AttributeOccurrence(attribute: titleAttribute, range: titleRange)
            attributeApplications.append(titleAttributeApplication)
            
            let addressAttribute = Attribute(key: .foregroundColor, value: NSColor.systemYellow)
            let addressRange = match.range(withName: linkAddressKeywordRegexLabel)
            let addressAttributeApplication = AttributeOccurrence(attribute: addressAttribute, range: addressRange)
            attributeApplications.append(addressAttributeApplication)
            
            return attributeApplications
        }
        
        let linksRegexPattern = "(?<\(linkTitleKeywordRegexLabel)>\\[(?=[^\\(\\)\\[\\]]*\\]\\().*?\\])(?<\(linkAddressKeywordRegexLabel)>\\(.*?\\))"
        let linksKeyword = Keyword(regexPattern: linksRegexPattern, attributeApplicationsProvider: linksAttributeApplicationsProvider)
        
        return linksKeyword
    }
}
