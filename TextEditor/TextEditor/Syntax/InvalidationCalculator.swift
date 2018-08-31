//
//  InvalidationCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 8/31/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class InvalidationCalculator {
    
    func rectangle() -> NSRect {
        
        return NSRect(x: 0, y: 0, width: 100, height: 100)
        
        //TODO: implement the following:
        
        //calculate invalid rectangle
        // figure out character range - iterate over the regexMatches on the previous string AND the regexMatches on the new string. if there is a match that encompasses the editedRange(includes the editedRange and beyond (either before or after)) AND that match does not exist on the other set of regexMatches = then proceed with following steps
        // figure out the range for that regex match
        // get the glyphRange of that characterRange (layoutManager.glyphRangeForCharacterRange:characterRange, actualCharacterRange:nil)
        // get the bounding rect of that glyphRange (layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer))
        // add bounding rect rect to list of rects that need to be invalidated
        // calculate one rect from the resulting list of rectangles
    }
}
