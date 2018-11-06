//
//  IndeterminateGroupingRuleProperties.swift
//  TextEditor
//
//  Created by charles johnston on 10/30/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class IndeterminateGroupingRuleProperties: NSObject, NSCoding {
    static func == (lhs: IndeterminateGroupingRuleProperties, rhs: IndeterminateGroupingRuleProperties) -> Bool {
        
        return lhs.ascending == rhs.ascending && lhs.indeterminateGroupLabel == rhs.indeterminateGroupLabel
    }
    
    
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
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(ascending, forKey: "ascending")
        aCoder.encode(indeterminateGroupLabel, forKey: "indeterminateGroupLabel")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.ascending = aDecoder.decodeBool(forKey: "ascending")
        self.indeterminateGroupLabel = aDecoder.decodeObject(forKey: "indeterminateGroupLabel") as! String
    }
}
