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
    let regexPatternCodingKey = "regexPatternCodingKey"
    let labelGroupTitleCodingKey = "labelGroupTitleCodingKey"
    let indeterminateGroupingRulePropertiesCodingKey = "indeterminateGroupingRulePropertiesCodingKey"
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(regexPattern, forKey: regexPatternCodingKey)
        aCoder.encode(labelGroupTitle, forKey: labelGroupTitleCodingKey)
        aCoder.encode(indeterminateGroupingRuleProperties, forKey: indeterminateGroupingRulePropertiesCodingKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.regexPattern = aDecoder.decodeObject(forKey: regexPatternCodingKey) as? String ?? .regexMatchNothing
        self.labelGroupTitle = aDecoder.decodeObject(forKey: labelGroupTitleCodingKey) as? String ?? ""
        self.indeterminateGroupingRuleProperties = aDecoder.decodeObject(forKey: indeterminateGroupingRulePropertiesCodingKey) as? IndeterminateGroupingRuleProperties
    }
}
