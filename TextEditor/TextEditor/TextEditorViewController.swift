//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

public class TextEditorViewController: NSViewController, NSTextViewDelegate, TextStorageDelegate, NSTextStorageDelegate {
    
    // MARK: - Properties
    // TODO: make these non-optional?
    // TODO: see if these properties should be moved somewhere more appropriate. maybe they should be here. idk
    var textEditorView: TextEditorView!
    var textStorage: TextEditorTextStorage!
    
    var layoutManager: TextEditorLayoutManager? = nil
    var textContainer: NSTextContainer? = nil
    
    // MARK: - Constructors
    public static func createInstance() -> TextEditorViewController? {
        
        let bundle = Bundle(for: TextEditorViewController.self)
        let storyboardName = NSStoryboard.Name(rawValue: String(describing: TextEditorViewController.self))
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
        
        viewController!.commonInit()
        
        return viewController
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        //
    }
    
    public override func viewDidLoad() {
        
        createTextView()
        textEditorView.lnv_setUpLineNumberView()
    }
    
    private func createTextView() {
    
        // 1. create text storage that backs the editor
        //TODO: hook font up to settings/preferences
        let attributes = [NSAttributedStringKey.font : NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)]
        //TODO: hook string up to opened file
        let string = ""
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        textStorage = TextEditorTextStorage()
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        textStorage.font = monospaceFont
        textStorage.myDelegate = self
        textStorage.delegate = self
        textStorage.append(attributedString)
        
        let scrollViewRect = view.bounds
        
        // 2. create the layout manager
        layoutManager = TextEditorLayoutManager()
//        layoutManager?.allowsNonContiguousLayout = true
        guard let layoutManager = layoutManager else {
            print("error creating text view - layoutManager")
            return
        }
        
        // 3. create a text container
        let containerSize = CGSize(width: scrollViewRect.width, height: CGFloat.greatestFiniteMagnitude)
        textContainer = TextEditorTextContainer(size: containerSize)
        guard let textContainer = textContainer else {
            print("error creating text view - textContainer")
            return
        }
        
        // TODO: handle word-wrap
        textContainer.widthTracksTextView = false
        textContainer.containerSize = NSSize(width: .greatestFiniteMagnitude, height: containerSize.height)
//        container.widthTracksTextView = true
        
        // 4. assemble
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 5. put textView in scrollView
        let scrollView = NSScrollView(frame: scrollViewRect)
        let contentSize = scrollView.contentSize
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autoresizingMask = [.width, .height]
        
        // 6. create textview
        let textEditorViewFrame = NSRect(origin: .zero, size: contentSize)
        textEditorView = TextEditorView(frame: textEditorViewFrame, textContainer: textContainer)
        textEditorView.minSize = NSSize(width: 0, height: contentSize.height)
        textEditorView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textEditorView.isVerticallyResizable = true
        textEditorView.isHorizontallyResizable = false
        textEditorView.autoresizingMask = .width
        textEditorView.delegate = self
        
        // 7. assemble
        scrollView.documentView = textEditorView
        
        view.addSubview(scrollView)
    }
    
    // MARK: my text storage delegate
    func didChangeAttributeOccurrences(changedAttributeOccurrences: [AttributeOccurrence]) {

        guard let layoutManager = self.layoutManager else {
            return
        }
        
//        for changedAttributeOccurrence in changedAttributeOccurrences {
//
//            layoutManager.invalidateDisplay(forCharacterRange: changedAttributeOccurrence.range)
//        }
        
        
//
//        guard let textView = self.textEditorView else {
//            return
//        }
//
//        let rect = NSRect(x: 0, y: 0, width: 100, height: 100)
//        textView.setNeedsDisplay(rect)
    }
    
    // MARK: NSTextStorage Delegate
    public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
//        self.textStorage.updateAllAttributeOccurrences()
//        self.textStorage.applyStylesToRange(searchRange: editedRange)
    }
}
