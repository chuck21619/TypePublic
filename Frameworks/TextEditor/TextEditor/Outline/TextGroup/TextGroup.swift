//
//  TextGroup.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroup: Equatable, CustomStringConvertible {
    
    // MARK: - Properties
    let title: String
    private var iterator: TextGroupIterator? = nil
    let token: TextGroupToken?
    weak var parentTextGroup: TextGroup? = nil
    var textGroups: [TextGroup] = [] {
        
        didSet {
            
            for textGroup in textGroups {
                
                textGroup.parentTextGroup = self
            }
        }
    }
    
    // MARK: - Methods
    // MARK: Constructor
    init(title: String, textGroups: [TextGroup] = [], token: TextGroupToken? = nil) {
        
        self.title = title
        self.textGroups = textGroups
        self.token = token
    }
    
    // MARK: etc.
    func createIterator() -> TextGroupIterator {
        
//        if iterator == nil {
            iterator = TextGroupIterator(textGroups: textGroups)
//        }
        
        return iterator!
    }
    
    // MARK: - Description
    var description: String {

//        return ""
        
        var string = ""
        
        var indentLevel = 0
        
        var currentTextGroup: TextGroup? = self
        
        let iterator = self.createIterator()
        
        while currentTextGroup != nil {
            
            for _ in 0..<indentLevel {
                
                string = "\(string)    "
            }
            string = "\(string)\(currentTextGroup!.title)\n"
            
            let nextTextGroup = iterator.next()
            
            if let nextTextGroup = nextTextGroup {
                
                if currentTextGroup?.textGroups.contains(nextTextGroup) == true {
                    
                    indentLevel += 1
                }
                else {
                    
                    var recursiveTextGroup: TextGroup? = currentTextGroup
                    
                    while nextTextGroup.parentTextGroup?.textGroups.contains(recursiveTextGroup!) == false {
                        
                        indentLevel -= 1
                        recursiveTextGroup = recursiveTextGroup?.parentTextGroup
                    }
                }
            }
            
            currentTextGroup = nextTextGroup
        }
        
        return string
    }
    
    // MARK: - Equatable
    static func == (lhs: TextGroup, rhs: TextGroup) -> Bool {
        
        let isEqual = lhs.title == rhs.title &&
            lhs.textGroups == rhs.textGroups &&
            lhs.token == rhs.token
        
        return isEqual
    }
}
