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
