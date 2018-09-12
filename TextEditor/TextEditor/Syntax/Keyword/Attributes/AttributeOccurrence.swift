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
    let attributeRange: NSRange
    
    //range which the attribute effects and is effected by
    //example: for links [linkName](linkAddress) - the linkName attributeRange is only inside the square brackets [], but is effected by the larger range that includes the linkAddress. The same is true for the linkAddress
    let effectiveRange: NSRange
    
    // MARK: - Constructors
    init(attribute: Attribute, attributeRange: NSRange) {
        
        self.init(attribute: attribute, attributeRange: attributeRange, effectiveRange: attributeRange)
    }
    
    init(attribute: Attribute, attributeRange: NSRange, effectiveRange: NSRange) {
        
        self.attribute = attribute
        self.attributeRange = attributeRange
        self.effectiveRange = effectiveRange
    }
    
    // MARK: - Methods
    // TODO: clean up this method
    func intersects(range: NSRange) -> Bool {
        
        if self.effectiveRange.location >= range.location {
            
            if self.effectiveRange.location <= range.location + range.length {
                
                return true
            }
            else {
                
                return false
            }
        }
        else {
            
            if self.effectiveRange.location + self.effectiveRange.length >= min(range.location, range.location + range.length) {
                
                return true
            }
            else {
                
                return false
            }
        }
    }
    
    func intersects(location: Int) -> Bool {
        
        if self.effectiveRange.contains(location) {
            return true
        }
        
        return false
    }
}

extension AttributeOccurrence: Hashable {
    
    var hashValue: Int {
        // TODO: is this correct?
        return (attributeRange.hashValue * effectiveRange.hashValue)
    }
    
    static func == (lhs: AttributeOccurrence, rhs: AttributeOccurrence) -> Bool {
        return lhs.attributeRange == rhs.attributeRange
            && lhs.attribute == rhs.attribute
            && lhs.effectiveRange == rhs.effectiveRange
    }
}
