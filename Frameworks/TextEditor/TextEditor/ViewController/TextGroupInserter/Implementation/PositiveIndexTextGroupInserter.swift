//
//  PositiveIndexTextGroupPlacer.swift
//  TextEditor
//
//  Created by charles johnston on 11/13/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class PositiveIndexTextGroupInserter: TextGroupInserter {
    
    func adjacentTextGroup(textGroups: [TextGroup], index: Int) -> TextGroup {
        
        let aboveTextGroup = textGroups[index-1]
        
        return aboveTextGroup
    }
    
    func locationToInsert(adjacentTextGroupRange: NSRange) -> Int {
        
        let locationToInsert = adjacentTextGroupRange.location + adjacentTextGroupRange.length
        
        return locationToInsert
    }
}
