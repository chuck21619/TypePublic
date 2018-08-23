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
        
        let italicFont = NSFontManager().convert(NSFont.systemFont(ofSize: 11), toHaveTrait: .italicFontMask)
        let boldFont = NSFont.boldSystemFont(ofSize: 11)
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        
        switch definedLanguage {
            
        case .Markdown:
            
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

                            // [link title](www.linkAddress.com) // this is for the link title
                            makeKeyword("(?<=\\[)(.*?)(?=\\])(?=\\]\\(.*\\))", .foregroundColor, NSColor.purple),
                
//                             //[link title](www.linkAddress.com) // this is for the link address
//                            makeKeyword("(?<=\\[.*\\].*\\()(.*?)(?=\\))", .foregroundColor, NSColor.purple)
                            ]
            
            let language = Language(name: "Markdown", definedLanguage: definedLanguage, keywords: keywords)
            return language
        }
    }
    
    private func makeKeyword( _ regexPattern: String, _ attributeKey: NSAttributedStringKey, _ attributeValue: Any) -> Keyword {
        
        let attribute = Attribute(key: attributeKey, value: attributeValue)
        let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
        
        return keyword
    }
}
