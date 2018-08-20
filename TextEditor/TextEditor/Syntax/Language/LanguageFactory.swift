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
            
            let attribute = Attribute(key: .foregroundColor, value: NSColor.blue)
            let regexPattern = RegularExpressionPatternFactory.pattern(keyword: "blue")
            let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
            
            let attribute2 = Attribute(key: .foregroundColor, value: NSColor.brown)
            let regexPattern2 = RegularExpressionPatternFactory.pattern(beginning: "^s*#", ending: "")
            let keyword2 = Keyword(regexPattern: regexPattern2, attribute: attribute2)
            
            let keywords: [Keyword] = [keyword, keyword2]
            let language = Language(name: "Markdown", definedLanguage: .Markdown, keywords: keywords)
            return language
        }
    }
}
