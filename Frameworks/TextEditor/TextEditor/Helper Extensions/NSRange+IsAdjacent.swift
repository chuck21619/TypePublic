//
//  NSRange+IsAdjacent.swift
//  TextEditor
//
//  Created by charles johnston on 9/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension NSRange {

    func isAdjacent(to otherRange:NSRange) -> Bool {
        
        let positiveSelf = self.positive
        let positiveOtherRange = otherRange.positive
        
        let adjacentToBottom = (positiveSelf.location + positiveSelf.length) == positiveOtherRange.location
        let adjacentToTop = (positiveOtherRange.location + positiveOtherRange.length) == self.location
        
        let isAdjacent = adjacentToTop || adjacentToBottom
        
        return isAdjacent
    }
}
