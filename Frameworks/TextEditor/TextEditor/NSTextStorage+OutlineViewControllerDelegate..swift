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
    
    func string(for textGroup: TextGroup, outlineModel: OutlineModel?) -> NSAttributedString? {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return nil
        }
        
        let attributedString = self.attributedSubstring(from: range)
        
        let rangeOfLastCharacter = NSRange(location: attributedString.length-1, length: 1)
        
        let lastCharacter = attributedString.attributedSubstring(from: rangeOfLastCharacter)
        
        if lastCharacter.string != "\n" {
            
            return attributedString.appended("\n")
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
        
        //if inserting string to end of document, and the end of the document is not a newline character. add a new line charachter so the textgorup is not appended inside the last textgroup

        var attributedStringToInsert = attributedString
        if locationToInsert == self.string.count {
            
            if self.string.suffix(1) != "\n" {
                
                attributedStringToInsert = attributedString.prepended("\n")
            }
        }
        
        self.insert(attributedStringToInsert, at: locationToInsert)
    }
    
    func removeTextGroup(_ textGroup: TextGroup, outlineModel: OutlineModel?) {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return
        }
        
        self.replaceCharacters(in: range, with: "")
        outlineModel?.reCalculateTextGroups(replacingRange: range, with: "")
    }
    
    func beginUpdates() {
        self.beginEditing()
    }
    
    func endUpdates() {
        self.endEditing()
    }
}
