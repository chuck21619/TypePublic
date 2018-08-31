//
//  TextEditorTextStorage.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextStorageDelegate {
    func didAddAttributes()
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
        
        // reset attributes to normal
        // TODO: get font and color from settings
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        let normalFontAttribute = Attribute(key: .font, value: monospaceFont)
        let normalFontAttributeOccurrence = AttributeOccurrence(attribute: normalFontAttribute, range: searchRange)
        
        let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
        let normalColorAttributeOccurrence = AttributeOccurrence(attribute: normalColorAttribute, range: searchRange)
        
        let resetAttributes = [normalFontAttributeOccurrence, normalColorAttributeOccurrence]
        
        // get attributes from syntax parser
        let parsedAttributes = syntaxParser.attributes(for: self.backingStore.string, changedRange: searchRange)
        
        //calculate invalidation rectangles
        // figure out character range - iterate over the regexMatches on the previous string AND the regexMatches on the new string. if there is a match that encompasses the editedRange(includes the editedRange and beyond (either before or after)) AND that match does not exist on the other set of regexMatches = then proceed with following steps
        // figure out the range for that regex match
        // get the glyphRange of that characterRange (layoutManager.glyphRangeForCharacterRange:characterRange, actualCharacterRange:nil)
        // get the bounding rect of that glyphRange (layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer))
        // add bounding rect rect to list of rects that need to be invalidated
        
        // all attributes to apply
        let attributes = resetAttributes + parsedAttributes
        
        for attributeOccurence in attributes {
            
            self.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.range)
        }
        
        //send invalidation rect in delegate callback
        self.myDelegate?.didAddAttributes()
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
    
    override func processEditing() {
        
        super.processEditing()
        
        let rangeToApplyAttributes = rangeToPerformAttributeReplacements(editedRange: editedRange)
        applyStylesToRange(searchRange: rangeToApplyAttributes)
    }
}
