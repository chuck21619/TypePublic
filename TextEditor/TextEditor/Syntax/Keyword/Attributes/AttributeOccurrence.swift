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
    
    func intersects(range: NSRange) -> Bool {
        
        if self.range.location >= range.location {
            
            if self.range.location <= range.location + range.length {
                
                return true
            }
            else {
                
                return false
            }
        }
        else {
            
            if self.range.location + self.range.length >= min(range.location, range.location + range.length) {
                
                return true
            }
            else {
                
                return false
            }
        }
    }
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
