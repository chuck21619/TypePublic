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
        
        // 1. create some attributes
        let boldFont = NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        let normalFont = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        let blueColor = NSColor.blue
        let normalColor = NSColor.black
        
        let boldAttributes = [NSAttributedStringKey.font : boldFont]
        let normalFontAttributes = [NSAttributedStringKey.font : normalFont]
        let blueAttributes = [NSAttributedStringKey.foregroundColor : blueColor]
        let normalColorAttributes = [NSAttributedStringKey.foregroundColor : normalColor]
        
        // reset to normal?
        self.addAttributes(normalColorAttributes, range: searchRange)
        self.addAttributes(normalFontAttributes, range: searchRange)
        
//        // 2. match items surrounded by asterisks
//        let regexStr = "(\\*\\w+(\\s\\w+)*\\*)"
//        guard let regex = try? NSRegularExpression(pattern: regexStr, options: .caseInsensitive) else {
//            return
//        }
        
        // 2.a
        let regexStr2 = "\\b(blue)\\b"
        guard let regex2 = try? NSRegularExpression(pattern: regexStr2) else {
            return
        }
        
//        // 3. iterate over each match, making the text bold
//        regex.enumerateMatches(in: backingStore.string, range: searchRange) { (match, flags, stop) in
//            
//            guard let match = match else {
//                return
//            }
//            
//            let matchRange = match.range(at: 1)
//            self.addAttributes(boldAttributes, range: matchRange)
//            
////            // 4. reset the style to the original
////            let maxRange = matchRange.location + matchRange.length
////            if maxRange + 1 < self.length {
////                self.addAttributes(normalFontAttributes, range: NSMakeRange(maxRange, 1))
////            }
//        }
        
        // 3.a
        regex2.enumerateMatches(in: backingStore.string, range: searchRange) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            let matchRange = match.range(at: 1)
            self.addAttributes(blueAttributes, range: matchRange)
            
//            // 4. reset the style to the original
//            let maxRange = matchRange.location + matchRange.length
//            if maxRange + 1 < self.length {
//                self.addAttributes(normalColorAttributes, range: NSMakeRange(maxRange, 1))
//            }
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
