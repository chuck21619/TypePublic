//
//  TextEditorTypeSetter.swift
//  TextEditor
//
//  Created by charles johnston on 11/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorTypeSetter: NSATSTypesetter {
    
    override func layoutCharacters(in characterRange: NSRange, for layoutManager: NSLayoutManager, maximumNumberOfLineFragments maxNumLines: Int) -> NSRange {
        
        let result = super.layoutCharacters(in: characterRange, for: layoutManager, maximumNumberOfLineFragments: maxNumLines)
        
//        super.layoutCharacters(in: <#T##NSRange#>, for: <#T##NSLayoutManager#>, maximumNumberOfLineFragments: <#T##Int#>)
        return result
    }
}

class TestTextAttachment: NSTextAttachment{//}, NSPasteboardWriting, NSPasteboardReading {
    
//    override init(data contentData: Data?, ofType uti: String?) {
//        print("")
//        super.init(data: contentData, ofType: uti)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
//
//        let string = "someString"
//        let stringAsData = string.data(using: .utf8)
//
//        super.init(data: stringAsData, ofType: "someType")
//    }
//
//
//
    static let testTextAttachmentPasteboardType = NSPasteboard.PasteboardType(rawValue: "\(Bundle.main.bundleIdentifier ?? "Type").TestTextAttachment")
    
    var myString = "myString"
//
//    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
//
//        return [TestTextAttachment.testTextAttachmentPasteboardType]
//    }
//
//    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
//
//        return [TestTextAttachment.testTextAttachmentPasteboardType]
//    }
//    
//    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
//        
//        return "string representing the image which represents the collapsed text"
//    }
}
