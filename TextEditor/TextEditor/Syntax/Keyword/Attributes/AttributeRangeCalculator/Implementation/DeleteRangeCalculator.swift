//
//  DeleteRangeCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 9/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class DeleteRangeCalculator: AttributeRangeCalculator {
    
    func calcRange(attributeOccurrence: AttributeOccurrence, editedRange: NSRange, changeInLength: Int) -> NSRange? {
        
        let range: NSRange?
        
        let attributeLocation = attributeOccurrence.effectiveRange.location
        let attributeLength = attributeOccurrence.effectiveRange.length
        let editedLocation = editedRange.location
        
        if editedLocation < attributeLocation {
            
            if editedLocation - changeInLength < attributeLocation + attributeLength {
                
                let location = editedLocation
                let overlap = (editedLocation - changeInLength) - attributeLocation
                let length = attributeLength - max(0, overlap)
                
                range = NSRange(location: location, length: length)
            }
            else {
                
                range = nil
            }
        }
        else  {
            
            if editedLocation - changeInLength > attributeLocation + attributeLength {
                
                let location = attributeLocation
                let overlap = (attributeLocation + attributeLength) - editedLocation
                let length = attributeLength - max(0, overlap)
                
                range = NSRange(location: location, length: length)
            }
            else {
                
                let location = attributeLocation
                let length = attributeLength + changeInLength
                
                range = NSRange(location: location, length: length)
            }
        }
        
        return range
    }
}
