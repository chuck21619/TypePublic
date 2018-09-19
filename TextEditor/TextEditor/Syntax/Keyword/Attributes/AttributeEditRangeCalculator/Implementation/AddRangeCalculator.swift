//
//  AddRangeCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 9/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class AttributeAddRangeCalculator: AttributeEditRangeCalculator {
    
    func calcRange(attributeOccurrence: AttributeOccurrence, editedRange: NSRange, changeInLength: Int) -> NSRange? {
        
        let range: NSRange?
        
        let attributeLocation = attributeOccurrence.effectiveRange.location
        let attributeLength = attributeOccurrence.effectiveRange.length
        let editedLocation = editedRange.location
        
        let editedLocationIsInBetweenAttributeRange = editedLocation > attributeLocation && editedLocation < attributeLocation + attributeLength
        let editedLocationIsLessThanAttributeLocation = editedLocation < attributeLocation
        
        if editedLocationIsLessThanAttributeLocation {
            
            let location = attributeLocation + changeInLength
            let length = attributeLength
            
            range = NSRange(location: location, length: length)
        }
        else {
            
            if editedLocationIsInBetweenAttributeRange {
                
                let location = attributeLocation
                let length = attributeLength + changeInLength
                
                range = NSRange(location: location, length: length)
            }
            else {
                
                range = attributeOccurrence.effectiveRange
            }
        }
        
        return range
    }
}
