//
//  CompositeTextGroupIterator.swift
//  TextEditor
//
//  Created by charles johnston on 10/24/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class CompositeTextGroupIterator: TextGroupIterator {
    
    var stack: [TextGroupIterator] = []
    
    init(textGroupIterator: TextGroupIterator) {
        
        stack.append(textGroupIterator)
    }
    
    func next() -> TextGroup? {
        
        guard hasNext() == true, let iterator = stack.last, let textGroup = iterator.next() else {
            
            return nil
        }
        
        stack.append(textGroup.createIterator())
        
        return textGroup
    }
    
    func hasNext() -> Bool {
        
        guard let iterator = stack.last else {
            
            return false
        }
        
        if iterator.hasNext() == false {
            
            stack.removeLast()
            return hasNext()
        }
        else {
            
            return true
        }
    }
}
