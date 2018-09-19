//
//  ReplaceRangeCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 9/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class AttributeReplaceRangeCalculator: AttributeEditRangeCalculator {
    
    func calcRange(attributeOccurrence: AttributeOccurrence, editedRange: NSRange, changeInLength: Int) -> NSRange? {
        
        return attributeOccurrence.effectiveRange
    }
}
