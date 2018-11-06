//
//  TextGroupingRule.swift
//  TextEditor
//
//  Created by charles johnston on 10/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroupingRule: NSObject, NSCoding {
    
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
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(regexPattern, forKey: "regexPattern")
        aCoder.encode(labelGroupTitle, forKey: "labelGroupTitle")
        aCoder.encode(indeterminateGroupingRuleProperties, forKey: "indeterminateGroupingRuleProperties")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.regexPattern = aDecoder.decodeObject(forKey: "regexPattern") as! String
        self.labelGroupTitle = aDecoder.decodeObject(forKey: "labelGroupTitle") as! String
        self.indeterminateGroupingRuleProperties = aDecoder.decodeObject(forKey: "indeterminateGroupingRuleProperties") as? IndeterminateGroupingRuleProperties
    }
}
