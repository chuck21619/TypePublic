//
//  Attribute.swift
//  TextEditor
//
//  Created by charles johnston on 8/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct Attribute {
    
    let key: NSAttributedString.Key
    let value: Any
}

extension Attribute: Equatable {
    
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        // FIXME: this is not really equal
        // need to find a way to compare the values
        return lhs.key == rhs.key// && lhs.value == rhs.value
    }
}
