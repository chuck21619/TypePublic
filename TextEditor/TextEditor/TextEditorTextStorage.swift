//
//  TextEditorTextStorage.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextStorageDelegate {
    func didChangeAttributeOccurrences(changedAttributeOccurrences: [AttributeOccurrence])
}

class TextEditorTextStorage: NSTextStorage {

    let backingStore = NSMutableAttributedString()
    let syntaxParser = SyntaxParser()
    
    // TODO: rename delegate
    var myDelegate: TextStorageDelegate? = nil
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
        
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    // mandatory overrides to use our backingStore.string
    override func replaceCharacters(in range: NSRange, with str: String) {
//        print("replace characters in range:\(range) with string:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
//        print("setAttributes:\(attrs ?? [:]) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    // methods to apply attributes
    func applyStylesToRange(searchRange: NSRange) {
    
        // get attributes from syntax parser
        let attributeOccurrences = syntaxParser.attributeOccurrences(for: self.backingStore.string, range: searchRange, editedRange: self.editedRange)
        let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
        let invalidAttributeRanges = attributeOccurrences.invalidRanges
        
        
        let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
        
        for invalidAttributeRange in invalidAttributeRanges {
            
            self.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
        }
        
        
        for attributeOccurence in newAttributeOccurrences {
            
            self.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
        }
    }
    
    func rangeToPerformAttributeReplacements(editedRange: NSRange) -> NSRange {
        
        //range for all text
        return NSRange(backingStore.string.startIndex.encodedOffset ..< backingStore.string.endIndex.encodedOffset)
        
        //range for only edited line
//        var extendedRange = NSUnionRange(editedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(editedRange.location, 0)))
//        extendedRange = NSUnionRange(editedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(editedRange), 0)))
//
//        return extendedRange
    }
    
    func updateAllAttributeOccurrences() {

        let rangeToApplyAttributes = rangeToPerformAttributeReplacements(editedRange: editedRange)
        applyStylesToRange(searchRange: rangeToApplyAttributes)
    }
    
    override func processEditing() {

        super.processEditing()
        updateAllAttributeOccurrences()
    }
}
