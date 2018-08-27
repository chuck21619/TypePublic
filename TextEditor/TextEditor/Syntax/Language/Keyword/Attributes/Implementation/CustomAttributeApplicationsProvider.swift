//
//  CustomAttributeApplicationsProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class CustomAttributeApplicationsProvider: AttributeApplicationsProvider {
    
    // MARK: Properties
    var provider: (Keyword, String, NSRange)->[AttributeApplication]
    
    // MARK: Constructors
    init(provider: @escaping (Keyword, String, NSRange)->[AttributeApplication]) {
        
        self.provider = provider
    }
    
    // MARK: Methods
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeApplication] {
        
        let attributes = provider(keyword, string, changedRange)
        return attributes
    }
}
