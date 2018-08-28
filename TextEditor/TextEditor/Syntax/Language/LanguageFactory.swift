//
//  LanguageFactory.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class LanguageFactory {
    
    static let defaultLanguage: DefinedLanguage = .Markdown
    
    func createLanguage(_ definedLanguage: DefinedLanguage) -> Language {
        
        switch definedLanguage {
            
        case .Markdown:
            let markdown = createMarkdown()
            return markdown
        }
    }
    
    func createMarkdown() -> Language {
        
        let linkTitleKeywordRegexLabel = "linkTitle"
        let linkAddressKeywordRegexLabel = "linkAddress"
        
        let italicFont = NSFontManager().convert(NSFont.systemFont(ofSize: 11), toHaveTrait: .italicFontMask)
        let boldFont = NSFont.boldSystemFont(ofSize: 11)
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        
        func makeKeyword( _ regexPattern: String, _ attributeKey: NSAttributedStringKey, _ attributeValue: Any) -> Keyword {
            
            let attribute = Attribute(key: attributeKey, value: attributeValue)
            let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
            
            return keyword
        }
        
        let linksAttributeApplicationsProvider = BettCAAP { (match) -> [AttributeApplication] in
            
            var attributeApplications: [AttributeApplication] = []
            
            let titleAttribute = Attribute(key: .foregroundColor, value: NSColor.systemGreen)
            let titleRange = match.range(withName: linkTitleKeywordRegexLabel)
            let titleAttributeApplication = AttributeApplication(attribute: titleAttribute, range: titleRange)
            attributeApplications.append(titleAttributeApplication)
            
            let addressAttribute = Attribute(key: .foregroundColor, value: NSColor.systemYellow)
            let addressRange = match.range(withName: linkAddressKeywordRegexLabel)
            let addressAttributeApplication = AttributeApplication(attribute: addressAttribute, range: addressRange)
            attributeApplications.append(addressAttributeApplication)
            
            return attributeApplications
        }
        
        let linksRegexPattern = "(?<\(linkTitleKeywordRegexLabel)>\\[(?=[^\\(\\)\\[\\]]*\\]\\().*?\\])(?<\(linkAddressKeywordRegexLabel)>\\(.*?\\))"
        let linksKeyword = Keyword(regexPattern: linksRegexPattern, attributeApplicationsProvider: linksAttributeApplicationsProvider)
        
        let keywords = [// #h1 titles, ##h2 titles,  etc.
            makeKeyword("^\\s*#+", .foregroundColor, NSColor.brown),
            
            // _italic font_ *italic font*
            makeKeyword("(_|\\*)[^_\\*\\n]+\\1", .font, italicFont),
            
            // **bold font** __bold font__
            makeKeyword("(__|\\*\\*)[^_\\*\\n]+\\1", .font, boldFont),
            
            // `monospace font` belongs in backticks
            makeKeyword("`[^`\\n]+`", .font, monospaceFont),
            
            // *** horizontal rule // can use *** or --- or ___
            makeKeyword("^(___+|---+|\\*\\*\\*+)", .foregroundColor, NSColor.magenta),
            
            // + unordered list items // can use * or - or +
            makeKeyword("^\\s*(\\* |- |\\+ )", .foregroundColor, NSColor.orange),
            
            // 1. list items
            makeKeyword("^\\s*[0-9]\\. ", .foregroundColor, NSColor.red),
            
            // [link title](www.linkAddress.com)
            linksKeyword
        ]
        
        let language = Language(name: "Markdown", definedLanguage: .Markdown, keywords: keywords)
        return language
    }
}
