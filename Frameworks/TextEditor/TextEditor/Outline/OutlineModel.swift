//
//  OutlineModel.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineModel {
    
    // MARK: - Properties
    let language: Language
    var delegate: OutlineModelDelegate?
    var processing: Bool = false
    private var workItem: DispatchWorkItem? = nil
    
    // MARK: - Methods
    // MARK: Constructor
    init(language: Language, delegate: OutlineModelDelegate?) {
        
        self.language = language
        self.delegate = delegate
    }
    
    // MARK: real stuff
    func outline(textStorage: NSTextStorage) {
        
        textGroups(from: textStorage.string, completion: { (textGroups) in
            
            self.delegate?.didUpdate(textGroups: textGroups)            
        })
    }
    
    func textGroups(from string: String, completion: @escaping ([TextGroup]?)->()) {
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            guard let tokens = self.language.textGroupTokens(for: string, workItem: newWorkItem) else {
                completion(nil)
                return
            }
            
            var textGroups: [TextGroup] = []
            
            for token in tokens {
                
                let newTextGroup = TextGroup(title: token.label, token: token)
                
                var flattenedTextGroups: [TextGroup] = []
                
                let iterator = TextGroupIterator(textGroups: textGroups)
                while let textGroup = iterator.next() {
                    
                    flattenedTextGroups.append(textGroup)
                }
                
                let reversedTextGroups =  flattenedTextGroups.reversed()
                
                var noPreviousTextGroupsWithHigherPriority = true
                for textGroup in reversedTextGroups {
                    
                    guard let textGroupToken = textGroup.token else {
                        continue
                    }
                    
                    if self.language.priority(of: textGroupToken, isHigherThan: token) {
                        
                        textGroup.textGroups.append(newTextGroup)
                        
                        noPreviousTextGroupsWithHigherPriority = false
                        break
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
