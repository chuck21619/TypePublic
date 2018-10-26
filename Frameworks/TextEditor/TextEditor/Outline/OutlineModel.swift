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
        
        textGroups(from: textStorage.string, completion: { (textgroups) in
            
            print("groups : \(textgroups)")
        })
    }
    
    func textGroups(from string: String, completion: @escaping ([TextGroup])->()) {
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            guard let tokens = self.language.textGroupTokens(for: string, workItem: newWorkItem) else {
                completion([])
                return
            }
//            print(tokens)
            
            var textGroups: [TextGroup] = []
            
            for token in tokens {
                
                let newTextGroup = TextGroup(title: token.label, token: token)
                
                guard let firstTextGroup = textGroups.first else {
                    textGroups.append(newTextGroup)
                    continue
                }
                
                var allTextGroups: [TextGroup] = [firstTextGroup]
                
                let iterator = firstTextGroup.createIterator()
                while iterator.hasNext() {
                    
                    guard let textGroup = iterator.next() else {
                        continue
                    }
                    
                    allTextGroups.append(textGroup)
                }
                
                let reversedTextGroups = allTextGroups.reversed()
                
                var noPreviousTextGroupsWithHigherPriority = true
                for textGroup in reversedTextGroups {
                    
                    if self.language.priority(of: textGroup.token.groupingRule, isHigherThan: token.groupingRule) {
                        
                        noPreviousTextGroupsWithHigherPriority = false
                        
                        textGroup.textGroups.append(newTextGroup)
                    }
                }
                
                if noPreviousTextGroupsWithHigherPriority {
                    
                    textGroups.append(newTextGroup)
                }
            }
            
            completion(textGroups)
            
            newWorkItem = nil
        }
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
}
