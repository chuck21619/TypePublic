//
//  TextEditor.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorView: NSView {
    
    // MARK: constructors
    init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        self.commonInit()
    }
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
    func commonInit() {
        
        let textView = NSTextView(frame: .zero)
        self.addSubview(textView)
//        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
