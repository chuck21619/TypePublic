//
//  TextGroupIterator.swift
//  TextEditor
//
//  Created by charles johnston on 10/24/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OneLevelTextGroupIterator: TextGroupIterator {
    
    private let textGroups: [TextGroup]
    private var position: Int = 0
    
    init(textGroups: [TextGroup]) {
        
        self.textGroups = textGroups
    }
    
    func hasNext() -> Bool {
        
        return textGroups.indices.contains(position)
    }
    
    func next() -> TextGroup? {
        
        guard hasNext() else {
            return nil
        }
        
        let textGroup = textGroups[position]
        position += 1
        return textGroup
    }
}
