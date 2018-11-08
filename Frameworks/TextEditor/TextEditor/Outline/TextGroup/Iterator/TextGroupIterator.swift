//
//  CompositeTextGroupIterator.swift
//  TextEditor
//
//  Created by charles johnston on 10/24/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroupIterator: NSObject, NSCoding {
    
    var position = 0
    let textGroups: [TextGroup]
    var stack: [TextGroupIterator] = []
    
    init(textGroups: [TextGroup]) {
        
        self.textGroups = textGroups
        super.init()
        
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
    
    // MARK: - NSCoding
    let positionCodingKey = "positionCodingKey"
    let textGroupsCodingKey = "textGroupsCodingKey"
    let stackCodingKey = "stackCodingKey"
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(position, forKey: positionCodingKey)
        aCoder.encode(textGroups, forKey: textGroupsCodingKey)
        aCoder.encode(stack, forKey: stackCodingKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.position = aDecoder.decodeInteger(forKey: positionCodingKey)
        self.textGroups = aDecoder.decodeObject(forKey: textGroupsCodingKey) as? [TextGroup] ?? []
        self.stack = aDecoder.decodeObject(forKey: stackCodingKey) as? [TextGroupIterator] ?? []
    }
}
