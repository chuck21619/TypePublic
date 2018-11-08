//
//  IndeterminateGroupingRuleProperties.swift
//  TextEditor
//
//  Created by charles johnston on 10/30/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class IndeterminateGroupingRuleProperties: NSObject, NSCoding {
    
    // used to determine order when grouping rule contains indeterminate regex matches
    // example:
    //   # h1 title
    //   ## h2 title
    //
    // if true, will put lower number as higher priority
    // so in the above example, h1 title would have a higher priority than h2 title
    //
    // if regex matches are determinate, then value has no effect
    let ascending: Bool
    
    // label of the regular expression group of the indeterminate pattern
    let indeterminateGroupLabel: String
    
    init(ascending: Bool, indeterminateGroupLabel: String) {
        
        self.ascending = ascending
        self.indeterminateGroupLabel = indeterminateGroupLabel
    }
    
    // MARK: - Equatable
    static func == (lhs: IndeterminateGroupingRuleProperties, rhs: IndeterminateGroupingRuleProperties) -> Bool {
        
        return lhs.ascending == rhs.ascending && lhs.indeterminateGroupLabel == rhs.indeterminateGroupLabel
    }
    
    // MARK: - NSCoding
    let ascendingCodingKey = "ascendingCodingKey"
    let indeterminateGroupLabelCodingKey = "indeterminateGroupLabelCodingKey"
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(ascending, forKey: ascendingCodingKey)
        aCoder.encode(indeterminateGroupLabel, forKey: indeterminateGroupLabelCodingKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.ascending = aDecoder.decodeBool(forKey: ascendingCodingKey)
        self.indeterminateGroupLabel = aDecoder.decodeObject(forKey: indeterminateGroupLabelCodingKey) as? String ?? ""
    }
}
