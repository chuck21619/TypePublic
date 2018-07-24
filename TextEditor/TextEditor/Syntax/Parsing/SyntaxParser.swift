//
//  SyntaxParser.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class SyntaxParser {
    
    // MARK: - Constructors
    convenience init(delegate: SyntaxParserDelgate) {
        let languageFactory = LanguageFactory()
        let language = languageFactory.createLanguage(LanguageFactory.defaultLanguage)
        self.init(delegate: delegate, language: language)
    }
    
    init(delegate: SyntaxParserDelgate, language: Language) {
        self.delegate = delegate
        self.language = language
    }
    
    // MARK: - Properties
    var delegate: SyntaxParserDelgate
    var language: Language
    
    func parseText(_ string: String) {
        
//        let range = NSRange(location: 0, length: 1)
//        let attributedString = NSMutableAttributedString(string: string)
//        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: NSColor.blue, range: range)

        
        let attributedString = NSAttributedString(string: "test")
        
        self.delegate.didParseSyntax(string: attributedString)
    }
}
