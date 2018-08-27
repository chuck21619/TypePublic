//
//  CustomNSAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class CustomNSAttributeProvider: NSAttributeProvider {
    
    // MARK: Properties
    var provider: (String, NSRange)->[AttributeApplication]
    
    // MARK: Constructors
    init(provider: @escaping (String, NSRange)->[AttributeApplication]) {
        
        self.provider = provider
    }
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeApplication] {
        
        let attributes = provider(string, changedRange)
        return attributes
    }
}
