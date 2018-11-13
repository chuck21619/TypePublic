//
//  ZeroIndexTextGroupPlacer.swift
//  TextEditor
//
//  Created by charles johnston on 11/13/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class ZeroIndexTextGroupInserter: TextGroupInserter {
    
    func adjacentTextGroup(textGroups: [TextGroup], index: Int) -> TextGroup {
        
        let belowTextGroup = textGroups[index]
        
        return belowTextGroup
    }
    
    func locationToInsert(adjacentTextGroupRange: NSRange) -> Int {
        
        let locationToInsert = adjacentTextGroupRange.location
        
        return locationToInsert
    }
}
