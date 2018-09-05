//
//  TextEditorTextStorage.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextStorageDelegate {
    func didAddAttributes(lastAttributeOccurrences: [AttributeOccurrence], newAttributeOccurrences: [AttributeOccurrence])
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
    // TODO: move lastAttributeOccurrences to approprite class?
    var lastParsedAttributeOccurrences: [AttributeOccurrence] = []
    func applyStylesToRange(searchRange: NSRange) {
        
        // reset attributes to normal
        // TODO: get font and color from settings
        // TODO: it may be necessary (to increase performance) to try to use the same logic that InvalidationCalculator is doing in order only add attributes that are different (as opposed to wiping all the attributes with every keystroke, and then re-applying them)
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        let normalFontAttribute = Attribute(key: .font, value: monospaceFont)
        let normalFontAttributeOccurrence = AttributeOccurrence(attribute: normalFontAttribute, range: searchRange)
        
        let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
        let normalColorAttributeOccurrence = AttributeOccurrence(attribute: normalColorAttribute, range: searchRange)
        
        // TODO: use invalidateAttributes instead of applying 'reset' attributes
        let resetAttributeOccurrences = [normalFontAttributeOccurrence, normalColorAttributeOccurrence]
        
        // get attributes from syntax parser
        let parsedAttributeOccurrences = syntaxParser.attributeOccurrences(for: self.backingStore.string, changedRange: searchRange)
        
        // all attributes to apply
        let attributeOccurrences = resetAttributeOccurrences + parsedAttributeOccurrences

        // apply the attributes
//        for attributeOccurence in attributeOccurrences {
//
//            self.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
//        }
        
        let changedAttributeOccurrences = lastParsedAttributeOccurrences.difference(from: parsedAttributeOccurrences)
        
        for attributeOccurence in changedAttributeOccurrences {
            
            self.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
        }
        
        self.myDelegate?.didAddAttributes(lastAttributeOccurrences: lastParsedAttributeOccurrences, newAttributeOccurrences: parsedAttributeOccurrences)
        
        self.lastParsedAttributeOccurrences = parsedAttributeOccurrences
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
    
    func doThings() {

        let rangeToApplyAttributes = rangeToPerformAttributeReplacements(editedRange: editedRange)
        applyStylesToRange(searchRange: rangeToApplyAttributes)
    }
    
//    override func processEditing() {
//
//        super.processEditing()
//        
////        applyStylesToRange(searchRange: editedRange)
//    }
}
