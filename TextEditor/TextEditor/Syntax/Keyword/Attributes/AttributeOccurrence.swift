//
//  AttributeOccurrence.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct AttributeOccurrence {
    
    let attribute: Attribute
    let range: NSRange
}

extension AttributeOccurrence: Hashable {
    
    var hashValue: Int {
        // TODO: is this correct?
        return range.hashValue
    }
    
    static func == (lhs: AttributeOccurrence, rhs: AttributeOccurrence) -> Bool {
        return lhs.range == rhs.range && lhs.attribute == rhs.attribute
    }
}
