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
    func invalidateRanges(invalidRanges: [NSRange])
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
    var lastEditedRange: NSRange = NSRange(location: 0, length: 0)
    var lastChangeInLength: Int = 0
    override func replaceCharacters(in range: NSRange, with str: String) {
//        print("replace characters in range:\(range) with string:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        lastEditedRange = editedRange
        lastChangeInLength = changeInLength
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
        let attributeOccurrences = syntaxParser.attributeOccurrences(for: self.backingStore.string, range: searchRange, editedRange: self.lastEditedRange, changeInLength: self.lastChangeInLength)
        let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
        let invalidAttributeRanges = attributeOccurrences.invalidRanges
        
        
        let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
        //TODO: get font from settings
        let normalFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        let normalFontAttribute = Attribute(key: .font, value: normalFont)
        
        
        // invalidating must happen first and new attributes may include the invalid ranges
        //TODO: consolidate invalid and new attributes
        for invalidAttributeRange in invalidAttributeRanges {
            
            self.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
            self.addAttribute(normalFontAttribute.key, value: normalFontAttribute.value, range: invalidAttributeRange)
        }
        
        
        for attributeOccurence in newAttributeOccurrences {
            
            self.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
        }
        
        
//        self.myDelegate?.invalidateRanges(invalidRanges: invalidAttributeRanges)
//        self.myDelegate?.didChangeAttributeOccurrences(changedAttributeOccurrences: newAttributeOccurrences)
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

        beginEditing()
        let rangeToApplyAttributes = rangeToPerformAttributeReplacements(editedRange: editedRange)
        applyStylesToRange(searchRange: rangeToApplyAttributes)
        endEditing()
    }
    
    override func processEditing() {

//        updateAllAttributeOccurrences()
        super.processEditing()
    }
}
