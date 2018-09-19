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
    func intersects(range: NSRange) -> Bool {
        
        let effectiveRange = self.effectiveRange
        let doesIntersectRange = effectiveRange.intersects(range)
        
        return doesIntersectRange
    }
    
    func intersects(location: Int) -> Bool {
        
        let effectiveRange = self.effectiveRange
        let doesIntersectRange = effectiveRange.contains(location)
        
        return doesIntersectRange
    }
    
    func isAdjacent(to range: NSRange) -> Bool {
        
        let effectiveRange = self.effectiveRange
        let isAdjacent = effectiveRange.isAdjacent(to: range)
        
        return isAdjacent
    }
    
    func effectiveRangeAfterEdit(editedRange: NSRange, changeInLength: Int) -> NSRange? {
        
        let range: NSRange?
        
        // Replacing Characters
        if changeInLength == 0 {
            
            range = self.effectiveRange
            
        }
            //Deleting Characters
        else if changeInLength < 0 {
            
            if editedRange.location < self.effectiveRange.location {
                
                //1
                if editedRange.location - changeInLength < self.effectiveRange.location + self.effectiveRange.length {
                    
                    let location = editedRange.location
                    let overlap = (editedRange.location - changeInLength) - self.effectiveRange.location
                    let length = self.effectiveRange.length - max(overlap, 0)
                    
                    range = NSRange(location: location, length: length)
                }
                    //4
                else {
                    
                    range = nil
                }
            }
            else  {
                
                //2
                if editedRange.location - changeInLength > self.effectiveRange.location + self.effectiveRange.length {
                    
                    let location = self.effectiveRange.location
                    let overlap = (self.effectiveRange.location + self.effectiveRange.length) - editedRange.location
                    let length = self.effectiveRange.length - max(0, overlap)
                    
                    range = NSRange(location: location, length: length)
                }
                    //3
                else {
                    
                    let location = self.effectiveRange.location
                    let length = self.effectiveRange.length + changeInLength
                    
                    range = NSRange(location: location, length: length)
                }
            }
        }
            // Adding Characters
        else {
            
            //6
            if editedRange.location <= self.effectiveRange.location {
                
                let location = self.effectiveRange.location + changeInLength
                let length = self.effectiveRange.length
                
                range = NSRange(location: location, length: length)
            }
            else {
                
                //7
                if editedRange.location > self.effectiveRange.location && editedRange.location < self.effectiveRange.location + self.effectiveRange.length {
                    
                    let location = self.effectiveRange.location
                    let length = self.effectiveRange.length + changeInLength
                    
                    range = NSRange(location: location, length: length)
                    
                }
                    //8
                else {
                    
                    range = self.effectiveRange
                }
            }
        }
        
        return range
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
