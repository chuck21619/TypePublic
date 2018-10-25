//
//  TextGroup.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroup {
    
    let title: String
    let textGroups: [TextGroup]?
    private var iterator: TextGroupIterator? = nil
    let token: TextGroupToken
    
    init(title: String, textGroups: [TextGroup]?, token: TextGroupToken) {
        
        self.title = title
        self.textGroups = textGroups
        self.token = token
    }
    
    func createIterator() -> TextGroupIterator {
        
        if iterator == nil {
            let oneLevelIterator = OneLevelTextGroupIterator(textGroups: textGroups ?? [])
            iterator = CompositeTextGroupIterator(textGroupIterator: oneLevelIterator)
        }
        
        guard let iterator = iterator else {
            
            fatalError()
        }
        
        return iterator
    }
}
