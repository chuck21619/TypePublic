//
//  TextEditorTextStorage.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorTextStorage: NSTextStorage {

    let backingStore = NSMutableAttributedString()
    let syntaxParser = SyntaxParser()
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
        
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    // mandatory overrides
    override func replaceCharacters(in range: NSRange, with str: String) {
        print("replace characters in range:\(range) with string:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
        print("setAttributes:\(attrs ?? [:]) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    // testing
    func applyStylesToRange(searchRange: NSRange) {
        
        // reset to normal
        let normalFontAttributes = [NSAttributedStringKey.font : NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)]
        let normalColorAttributes = [NSAttributedStringKey.foregroundColor : NSColor.black]
        self.addAttributes(normalColorAttributes, range: searchRange)
        self.addAttributes(normalFontAttributes, range: searchRange)
        
        // get attributes from syntax parser
        let attributes = syntaxParser.attributes(for: self.backingStore.string, changedRange: searchRange)
        
        for (attribute, range) in attributes {
            
            self.addAttributes(attribute.NSAttribute(), range: range)
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(searchRange: extendedRange)
    }
    
    override func processEditing() {
        super.processEditing()
        performReplacementsForRange(changedRange: self.editedRange)
    }
    
}
