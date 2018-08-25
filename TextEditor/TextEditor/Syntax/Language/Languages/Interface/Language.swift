//
//  Language.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol Language {
    
    var name: String { get }
    var definedLanguage: DefinedLanguage { get }
    var keywords: [Keyword] { get }
    
    func attributes(for string: String, changedRange: NSRange) -> [(attribute: Attribute, range: NSRange)]
}

//class Language {
//
//    let name: String
//    let definedLanguage: DefinedLanguage
//    let keywords: [Keyword]
//
//    init(name: String, definedLanguage: DefinedLanguage, keywords: [Keyword]) {
//
//        self.name = name
//        self.definedLanguage = definedLanguage
//        self.keywords = keywords
//    }
//
//    func attributes(for string: String, changedRange: NSRange) -> [(attribute: Attribute, range: NSRange)] {
//
//        retu
//    }
//}
