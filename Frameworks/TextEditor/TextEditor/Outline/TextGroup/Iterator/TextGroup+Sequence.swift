//
//  TextGroup+Sequence.swift
//  TextEditor
//
//  Created by charles johnston on 1/29/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

extension TextGroup: Sequence {
    
    func makeIterator() -> Iterator {
        return Iterator(root: self)
    }
    
    struct Iterator: IteratorProtocol {
        var nodes: [(index: Int, node: TextGroup)]
        
        init(root: TextGroup) {
            nodes = [(0, root)]
        }
        
        mutating func next() -> TextGroup? {
            defer {
                while let (index, node) = nodes.last, index >= node.textGroups.count {
                    nodes.removeLast()
                }
                
                if let (index, node) = nodes.popLast() {
                    nodes.append((index + 1, node))
                    nodes.append((0, node.textGroups[index]))
                }
            }
            
            return nodes.last?.node
        }
    }
}
