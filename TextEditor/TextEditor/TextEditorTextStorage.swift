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
        
//        var attributes = backingStore.attributes(at: location, effectiveRange: range)
//
//        guard let syntaxedAttributes = syntaxParser.attributes(at: location, for: backingStore.string) else {
//            return attributes
//        }
//
//        // update values
//        for (key, value) in syntaxedAttributes {
//            attributes[key] = value
//        }
//
//
//        guard let attributeOccurrences = syntaxParser.attributeOccurrences(for: self.backingStore.string, range: self.backingStore.string.maxNSRange, editedRange: editedRange, changeInLength: changeInLength) else {
//            return attributes
//        }
//        self.myDelegate?.invalidateRanges(invalidRanges: attributeOccurrences.invalidRanges)
//        self.myDelegate?.didChangeAttributeOccurrences(changedAttributeOccurrences: attributeOccurrences.newAttributeOccurrences)
//
//        return attributes
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
        
        DispatchQueue.global().async {
            
            // get attributes from syntax parser
            guard let attributeOccurrences = self.syntaxParser.attributeOccurrences(for: self.backingStore.string, range: searchRange, editedRange: self.lastEditedRange, changeInLength: self.lastChangeInLength) else {
                return
            }
            let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
            let invalidAttributeRanges = attributeOccurrences.invalidRanges
            
            
            let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
            //TODO: get font from settings
            let normalFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
            let normalFontAttribute = Attribute(key: .font, value: normalFont)
            
            guard self.backingStore.string.maxNSRange == searchRange else {
                //TODO: put this check in more places. particularly the language parsing
                print("CHECK IT")
                return
            }
            
            DispatchQueue.main.async {
                
                // invalidating must happen first and new attributes may include the invalid ranges
                //TODO: consolidate invalid and new attributes
                for invalidAttributeRange in invalidAttributeRanges {
                    
                    self.backingStore.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
                    self.backingStore.addAttribute(normalFontAttribute.key, value: normalFontAttribute.value, range: invalidAttributeRange)
                }
                
                for attributeOccurence in newAttributeOccurrences {
                    
                    self.backingStore.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
                }
                
                let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
                    return attributeOccurence.range
                })
                
                self.myDelegate?.invalidateRanges(invalidRanges: invalidAttributeRanges)
                self.myDelegate?.invalidateRanges(invalidRanges: newAttributesRanges)
            }
        }
    }
    
    func rangeToPerformAttributeReplacements(editedRange: NSRange) -> NSRange {
        
        //range for all text
        return backingStore.string.maxNSRange
        
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
