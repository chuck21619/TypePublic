//
//  TextGroupToken.swift
//  TextEditor
//
//  Created by charles johnston on 10/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct TextGroupToken: Equatable {
    
    let label: String
    
    // range at which the token resides within its string
    let range: NSRange
    
    // associated rule
    let groupingRule: TextGroupingRule
    
    // the amount of a token represented in an indeterminate rule
    // if associated rule is not indeterminate, then value has no effect
    // see TextGroupingRule.ascending for more details
    let tokenAmount: Int
    
    init(label: String, range: NSRange, groupingRule: TextGroupingRule, tokenAmount: Int = 0) {
        
        self.label = label
        self.range = range
        self.groupingRule = groupingRule
        self.tokenAmount = tokenAmount
    }
}
