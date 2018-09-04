//
//  InvalidationCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 8/31/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class InvalidationCalculator {
    
    func rectangle(lastAttributeOccurrences: [AttributeOccurrence], newAttributeOccurrences: [AttributeOccurrence], layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> NSRect? {
        
        let changedAttributeOccurrences = lastAttributeOccurrences.difference(from: newAttributeOccurrences)
        
        var allInvalidRectangles: [NSRect] = []
        for changedAttributeOccurrence in changedAttributeOccurrences {
            
            let invalidRectangle = calculateInvalidRectangle(changedAttributeOccurrence: changedAttributeOccurrence, layoutManager: layoutManager, textContainer: textContainer)
            allInvalidRectangles.append(invalidRectangle)
        }
        
        let rectangleUnion = calculateUnion(of: allInvalidRectangles)
        
        return rectangleUnion
    }
    
    private func calculateInvalidRectangle(changedAttributeOccurrence: AttributeOccurrence, layoutManager: NSLayoutManager, textContainer: NSTextContainer) -> NSRect {
        
        let characterRange = changedAttributeOccurrence.range
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        let invalidRectangle = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        return invalidRectangle
    }
    
    private func calculateUnion(of rectangles:[NSRect]) -> NSRect? {
        
        var rectangleUnion: NSRect? = rectangles.first
        
        for rectangle in rectangles {
            
            rectangleUnion = rectangleUnion?.union(rectangle)
        }
        
        return rectangleUnion
    }
}
