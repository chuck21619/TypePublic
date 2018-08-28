//
//  Keyword.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct Keyword {
    
    // MARK: Properties
    let regexPattern: String
    let attribute: Attribute?
    let attributeOccurencesProvider: AttributeOccurrencesProvider
    
    // MARK: Constructors
    // must be initialized with either an Attribute or an AttributeOccurrencesProvider
    
    private init(regexPattern: String, attribute: Attribute?, attributeOccurencesProvider: AttributeOccurrencesProvider) {
        
        self.regexPattern = regexPattern
        self.attribute = attribute
        self.attributeOccurencesProvider = attributeOccurencesProvider
    }
    
    init(regexPattern: String, attribute: Attribute) {

        self.init(regexPattern: regexPattern, attribute: attribute, attributeOccurencesProvider: SimpleAttributeOccurrencesProvider())
    }
    
    init(regexPattern: String, attributeOccurencesProvider: AttributeOccurrencesProvider) {

        self.init(regexPattern: regexPattern, attribute: nil, attributeOccurencesProvider: attributeOccurencesProvider)
    }
}
