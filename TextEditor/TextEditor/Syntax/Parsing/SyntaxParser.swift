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
    convenience init() {
        let languageFactory = LanguageFactory()
        let language = languageFactory.createLanguage(LanguageFactory.defaultLanguage)
        self.init(language: language)
    }
    
    init(language: Language) {
        self.language = language
    }
    
    // MARK: - Properties
    var language: Language
    
    func attributes(for string: String, changedRange: NSRange) -> [(attribute: Attribute, range: NSRange)] {
        
        //ask the language for attributes
//        language.attributes(for)
        
        var attributes: [(attribute: Attribute, range: NSRange)] = []
        
        for keyword in language.keywords {
            
            let regexStr = keyword.regexPattern
            
            
            guard let regex = try? NSRegularExpression(pattern: regexStr) else {
                return []
            }
            
            regex.enumerateMatches(in: string, range: changedRange) { (match, flags, stop) in
                
                guard let match = match else {
                    return
                }
                
                attributes.append((attribute: keyword.attribute, range: match.range))
            }
        }
        
        return attributes
    }
}
