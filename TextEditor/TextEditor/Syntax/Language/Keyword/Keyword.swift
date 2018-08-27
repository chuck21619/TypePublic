//
//  Keyword.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct Keyword {
    
    let regexPattern: String
    let attribute: Attribute
    let attributeApplicationsProvider: AttributeApplicationsProvider
    
    init(regexPattern: String, attribute: Attribute, attributeApplicationsProvider: AttributeApplicationsProvider = SimpleAttributeApplicationsProvider()) {
        
        self.regexPattern = regexPattern
        self.attribute = attribute
        self.attributeApplicationsProvider = attributeApplicationsProvider
    }
}
