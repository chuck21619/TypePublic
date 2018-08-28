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
            let markdown = MarkdownFactory().createMarkdown()
            return markdown
        }
    }
}
