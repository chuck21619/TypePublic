//
//  TextGroupToken.swift
//  TextEditor
//
//  Created by charles johnston on 10/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroupToken: NSObject, NSCoding {
    
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
    
    // MARK: - Equatable
    static func == (lhs: TextGroupToken, rhs: TextGroupToken) -> Bool {
        return lhs.label == rhs.label && lhs.range == rhs.range && lhs.groupingRule == rhs.groupingRule && lhs.tokenAmount == rhs.tokenAmount
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(label, forKey: "label")
        aCoder.encode(range, forKey: "range")
        aCoder.encode(groupingRule, forKey: "groupingRule")
        aCoder.encode(tokenAmount, forKey: "tokenAmount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.label = aDecoder.decodeObject(forKey: "label") as! String
        self.range = aDecoder.decodeObject(forKey: "range") as! NSRange
        self.groupingRule = aDecoder.decodeObject(forKey: "groupingRule") as! TextGroupingRule
        self.tokenAmount = aDecoder.decodeInteger(forKey: "tokenAmount")
    }
}
