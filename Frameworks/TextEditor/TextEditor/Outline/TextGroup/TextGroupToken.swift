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
    
    // range at which the token resides within the document
    var range: NSRange
    
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
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let rhs = object as? TextGroupToken else {
            return false
        }
        
        let lhs = self
        
        return lhs.label == rhs.label && lhs.range == rhs.range && lhs.groupingRule == rhs.groupingRule && lhs.tokenAmount == rhs.tokenAmount
    }
    
    
    // MARK: - NSCoding
    let labelCodingKey = "labelCodingKey"
    let rangeCodingKey = "rangeCodingKey"
    let groupingRuleCodingKey = "groupingRuleCodingKey"
    let tokenAmountCodingKey = "tokenAmountCodingKey"
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(label, forKey: labelCodingKey)
        aCoder.encode(range, forKey: rangeCodingKey)
        aCoder.encode(groupingRule, forKey: groupingRuleCodingKey)
        aCoder.encode(tokenAmount, forKey: tokenAmountCodingKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.label = aDecoder.decodeObject(forKey: labelCodingKey) as? String ?? ""
        
        let rangeNotFound = NSRange(location: NSNotFound, length: NSNotFound)
        self.range = aDecoder.decodeObject(forKey: rangeCodingKey) as? NSRange ?? rangeNotFound
        
        let emptyRule = TextGroupingRule(regexPattern: .regexMatchNothing, labelGroupTitle: "error", trimmedGroupTitle: "error")
        self.groupingRule = aDecoder.decodeObject(forKey: groupingRuleCodingKey) as? TextGroupingRule ?? emptyRule
        
        self.tokenAmount = aDecoder.decodeInteger(forKey: tokenAmountCodingKey)
    }
}
