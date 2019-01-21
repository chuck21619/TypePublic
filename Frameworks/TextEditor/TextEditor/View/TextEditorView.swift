//
//  TextEditor.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorView: NSTextView {
    
    // MARK: - Properties
    
    // prevent pasting rich text. always paste as plaintext
    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        
        return [NSPasteboard.PasteboardType.string]
    }
    
//    override func writeSelection(to pboard: NSPasteboard, type: NSPasteboard.PasteboardType) -> Bool {
//
//        print("")
//        return super.writeSelection(to: pboard, type: type)
//    }
    
// ********* replacing text groups with text attachments
    /*
    override func copy(_ sender: Any?) {

//        let pasteboard = NSPasteboard.general
//        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
//        pasteboard.setString("custom copy", forType: .string)



//        let pasteboard = NSPasteboard.general
//        pasteboard.declareTypes([TestTextAttachment.testTextAttachmentPasteboardType], owner: nil)
//
//        let string = "someString"
//        let stringAsData = string.data(using: .utf8)
//        let testAttachment = TestTextAttachment(data: stringAsData, ofType: "someType")
//
//        let stringFromData = String(data: testAttachment.contents!, encoding: .utf8)
//        pasteboard.setString(stringFromData!, forType: .string)


//
//        let range = self.selectedRange()
//        let str = self.string as NSString?
//        let substr = str?.substring(with: range)


        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([TestTextAttachment.testTextAttachmentPasteboardType], owner: nil)

        let attribute = textStorage?.attribute(.attachment, at: self.selectedRange().location, effectiveRange: nil)
        let testAttachment = attribute as! TestTextAttachment

        let stringInAttachment = testAttachment.myString
        pasteboard.setString(stringInAttachment.string, forType: .string)
    }
 */
    
    // MARK: - Methods
    
//    // MARK: Constructors
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.commonInit()
//    }
//
//    required init?(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//        self.commonInit()
//    }
//    
//    func commonInit() {
//
//    }
//
}
