//
//  TextEditor.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorView: NSTextView/*, NSTextStorageDelegate, SyntaxParserDelgate*/ {
    
    // prevent pasting rich text. always paste as plaintext
    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        
        return [NSPasteboard.PasteboardType.string]
    }
    
    // mouse tracking to show/hide outline
    override func updateTrackingAreas() {
        // TODO: mouse tracking area from viewController to view(this class)
        
        // handle updating the tracking area
        // example from apple (remove the current tracking areas from their views, release them, and then add new NSTrackingArea objects to the same views with recomputed regions): 
        //
//        - (void)updateTrackingAreas {
//            NSRect eyeBox;
//            [self removeTrackingArea:trackingArea];
//            [trackingArea release];
//            eyeBox = [self resetEye];
//            trackingArea = [[NSTrackingArea alloc] initWithRect:eyeBox
//                options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow)
//                owner:self userInfo:nil];
//            [self addTrackingArea:trackingArea];
//        }
    }
    
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
