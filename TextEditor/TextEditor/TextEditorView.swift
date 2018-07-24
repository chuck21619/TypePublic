//
//  TextEditor.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorView: NSTextView/*, NSTextStorageDelegate, SyntaxParserDelgate*/ {
    
    // MARK: - Properties
//    var syntaxParser: SyntaxParser?//(delegate: self)
//    
//    // MARK: - Constructors
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.commonInit()
//    }
//    
//    
//    required init?(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//        self.commonInit()
//    }
//    
//    func commonInit() {
//        
//        self.textStorage?.delegate = self
//        self.syntaxParser = SyntaxParser(delegate: self)
//    }
//    
//    // MARK: - NSTextStorageDelegate
//    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        
//        syntaxParser?.parseText(self.string)
//    }
//    
//    // MARK: - SyntaxParserDelgate
//    func didParseSyntax(string: NSAttributedString) {
//        
//        let range = NSRange(location: 0, length: 0)
//        self.textStorage?.replaceCharacters(in: range, with: string)
////        self.textStorage?.setAttributedString(string)
//    }
}
