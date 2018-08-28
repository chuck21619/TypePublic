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
    // must be initialized with either an Attribute or AttributeOccurrencesProvider or both
    
    public init(regexPattern: String, attribute: Attribute? = nil, attributeOccurencesProvider: AttributeOccurrencesProvider) {
        
        self.regexPattern = regexPattern
        self.attribute = attribute
        self.attributeOccurencesProvider = attributeOccurencesProvider
    }
    
    init(regexPattern: String, attribute: Attribute) {

        self.init(regexPattern: regexPattern, attribute: attribute, attributeOccurencesProvider: SimpleAttributeOccurrencesProvider())
    }
}
