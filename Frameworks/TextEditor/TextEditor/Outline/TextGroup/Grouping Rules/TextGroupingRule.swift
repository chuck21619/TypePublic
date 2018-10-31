//
//  TextGroupingRule.swift
//  TextEditor
//
//  Created by charles johnston on 10/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct TextGroupingRule: Equatable {
    
    let regexPattern: String
    
    // label of the regular expression group which contains the title
    // www.regular-expressions.info/refext.html
    let labelGroupTitle: String
    
    // holds properites for indeterminate rules
    // example of indeterminate pattern:
    // # h1 title
    // ## h2 title
    // etc.
    let indeterminateGroupingRuleProperties: IndeterminateGroupingRuleProperties?
    
    init(regexPattern: String, labelGroupTitle: String, indeterminateGroupingRuleProperties: IndeterminateGroupingRuleProperties? = nil) {
        
        self.regexPattern = regexPattern
        self.labelGroupTitle = labelGroupTitle
        self.indeterminateGroupingRuleProperties = indeterminateGroupingRuleProperties
    }
    
    // MARK: - Equatable
    static func == (lhs: TextGroupingRule, rhs: TextGroupingRule) -> Bool {
        
        let isEqual = lhs.regexPattern == rhs.regexPattern &&
                      lhs.labelGroupTitle == rhs.labelGroupTitle &&
                      lhs.indeterminateGroupingRuleProperties == rhs.indeterminateGroupingRuleProperties
        
        return isEqual
    }
    
}
