//
//  CompositeTextGroupIterator.swift
//  TextEditor
//
//  Created by charles johnston on 10/24/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroupIterator {
    
    var position = 0
    let textGroups: [TextGroup]
    var stack: [TextGroupIterator] = []
    
    init(textGroups: [TextGroup]) {
        
        self.textGroups = textGroups
        stack.append(self)
    }
    
    func next() -> TextGroup? {
        
        guard let currentIterator = stack.last else {
            
            return nil
        }
        
        if currentIterator !== self {
        
            if let nextTextGroup = currentIterator.next() {
                
                return nextTextGroup
            }
            else {
                
                stack.removeLast()
                return self.next()
            }
        }
        
        guard textGroups.indices.contains(position) else {
            
            return nil
        }
        
        let textGroup = textGroups[position]
        
        // add current textGroups iterator to the stack
        let nextIterator = TextGroupIterator(textGroups: textGroup.textGroups)
        stack.append(nextIterator)
        
        // update position
        position += 1
        
        return textGroup
    }
}
