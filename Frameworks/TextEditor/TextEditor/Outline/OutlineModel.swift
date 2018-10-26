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
        
        textGroups(from: textStorage.string, completion: { (textGroups) in
            
            guard let textGroups = textGroups else {
                return
            }
            
            print("groups : \(textGroups)")
        })
    }
    
    func textGroups(from string: String, completion: @escaping (TextGroup?)->()) {
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            guard let tokens = self.language.textGroupTokens(for: string, workItem: newWorkItem) else {
                completion(nil)
                return
            }
            
            let parentTextGroup = TextGroup(title: "parent")
            
            for token in tokens {
                
                let newTextGroup = TextGroup(title: token.label, token: token)
                
                var allTextGroups: [TextGroup] = [parentTextGroup]
                
                let iterator = parentTextGroup.createIterator()
                while iterator.hasNext() {
                    
                    guard let textGroup = iterator.next() else {
                        continue
                    }
                    
                    allTextGroups.append(textGroup)
                }
                
                let reversedTextGroups =  allTextGroups.reversed()
                
                var noPreviousTextGroupsWithHigherPriority = true
                for textGroup in reversedTextGroups {
                    
                    guard let textGroupToken = textGroup.token else {
                        continue
                    }
                    
                    if self.language.priority(of: textGroupToken.groupingRule, isHigherThan: token.groupingRule) {
                        
                        textGroup.textGroups.append(newTextGroup)
                        
                        noPreviousTextGroupsWithHigherPriority = false
                        break
                    }
                }
                
                if noPreviousTextGroupsWithHigherPriority {
                    
                    parentTextGroup.textGroups.append(newTextGroup)
                }
            }
            
            completion(parentTextGroup)
            
            newWorkItem = nil
        }
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
    }
}
