//
//  TextGroupPlacer.swift
//  TextEditor
//
//  Created by charles johnston on 11/13/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextGroupInserter {
    
    func adjacentTextGroup(textGroups: [TextGroup], index: Int) -> TextGroup
    func locationToInsert(adjacentTextGroupRange: NSRange) -> Int
}
