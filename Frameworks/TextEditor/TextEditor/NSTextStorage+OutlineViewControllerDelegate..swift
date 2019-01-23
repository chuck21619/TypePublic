//
//  NSTextStorage+OutlineViewControllerDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 1/23/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

// using extension instead of subclassing becuase NSTextStorage is a semi-concrete class
// see: https://developer.apple.com/documentation/uikit/nstextstorage - subclassing notes

extension NSTextStorage: OutlineViewControllerDelegate {    
    
    func title(for textGroup: TextGroup, outlineModel: OutlineModel?) -> NSAttributedString? {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return nil
        }
        
        let attributedString = self.attributedSubstring(from: range)
        
        let rangeOfLastCharacter = NSRange(location: attributedString.length-1, length: 1)
        
        let lastCharacter = attributedString.attributedSubstring(from: rangeOfLastCharacter)
        
        if lastCharacter.string != "\n" {
            
            // adds a newline character
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            let insertString = NSAttributedString(string: "\n")
            mutableAttributedString.append(insertString)
            
            return mutableAttributedString
        }
        
        return attributedString
    }
    
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int, outlineModel: OutlineModel?) {
        
        let textGroupInserter: TextGroupInserter
        
        if index == 0 {
            
            textGroupInserter = ZeroIndexTextGroupInserter()
        }
        else {
            
            textGroupInserter = PositiveIndexTextGroupInserter()
        }
        
        let adjacentTextGroup = textGroupInserter.adjacentTextGroup(textGroups: textGroup.textGroups, index: index)
        
        guard let rangeOfAdjacentTextGroup = outlineModel?.range(of: adjacentTextGroup) else {
            return
        }
        
        let locationToInsert = textGroupInserter.locationToInsert(adjacentTextGroupRange: rangeOfAdjacentTextGroup)
        
        self.insert(attributedString, at: locationToInsert)
    }
    
    func removeTextGroup(_ textGroup: TextGroup, outlineModel: OutlineModel?) {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return
        }
        
        self.replaceCharacters(in: range, with: "")
    }
    
    func beginUpdates() {
        self.beginEditing()
    }
    
    func endUpdates() {
        self.endEditing()
    }
}
