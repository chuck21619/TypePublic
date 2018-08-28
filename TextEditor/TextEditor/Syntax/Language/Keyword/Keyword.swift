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
    let attributeApplicationsProvider: AttributeOccurrencesProvider
    
    // MARK: Constructors
    // must be initialized with either an Attribute or an AttributeApplicationsProvider
    
    private init(regexPattern: String, attribute: Attribute?, attributeApplicationsProvider: AttributeOccurrencesProvider) {
        
        self.regexPattern = regexPattern
        self.attribute = attribute
        self.attributeApplicationsProvider = attributeApplicationsProvider
    }
    
    init(regexPattern: String, attribute: Attribute) {

        self.init(regexPattern: regexPattern, attribute: attribute, attributeApplicationsProvider: SimpleAttributeOccurrencesProvider())
    }
    
    init(regexPattern: String, attributeApplicationsProvider: AttributeOccurrencesProvider) {

        self.init(regexPattern: regexPattern, attribute: nil, attributeApplicationsProvider: attributeApplicationsProvider)
    }
}
