//
//  OutlineModel.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineModel {
    
    let language: Language
    var processing: Bool = false
    private var workItem: DispatchWorkItem? = nil
    
    init(language: Language) {
        
        self.language = language
    }
    
    func outline(textStorage: NSTextStorage) {
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            let tokens = self.language.textGroupTokens(for: textStorage.string, workItem: newWorkItem)
            print(tokens)
            
            newWorkItem = nil
        }
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
}
