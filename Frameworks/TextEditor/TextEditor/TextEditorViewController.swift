//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

//NSTrackingMouseEnteredAndExited
//NSTrackingActiveAlways
//self.view.addtrackingarea()

public class TextEditorViewController: NSViewController, NSTextViewDelegate, SyntaxHighlighterDelegate, NSTextStorageDelegate, OutlineViewControllerDelegate {
    
    // MARK: - Properties
    // TODO: make these non-optional or non-forced-optional?
    var textEditorView: TextEditorView!
    var textStorage: NSTextStorage!
    var layoutManager: TextEditorLayoutManager? = nil
    var textContainer: NSTextContainer? = nil
    
    var syntaxParser: SyntaxParser? = nil
    var syntaxHighlighter: SyntaxHighligher? = nil
    // used to prevent infinite loop. during processEditing, syntaxHighlighter adds attributes, which will call processEditing
    var ignoreProcessEditing = false
    
    var outlineModel: OutlineModel? = nil
    var outlineViewController: OutlineViewController? = nil
    var outlineMouseTrackingArea: NSTrackingArea? = nil
    
    // MARK: - Constructors
    public static func createInstance() -> TextEditorViewController? {
        
        let bundle = Bundle(for: TextEditorViewController.self)
        let storyboardName = String(describing: TextEditorViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
        
        return viewController
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        let languageFactory = LanguageFactory()
        let language = languageFactory.createLanguage(LanguageFactory.defaultLanguage)
        
        syntaxParser = SyntaxParser(language: language)
        
        guard let syntaxParser = syntaxParser else {
             return
        }
        
        syntaxHighlighter = SyntaxHighligher(syntaxParser: syntaxParser)
        syntaxHighlighter?.delegate = self
        
        outlineViewController = OutlineViewController.createInstance(delegate: self)
        outlineModel = OutlineModel(language: language, delegate: outlineViewController)
        outlineViewController?.model = outlineModel
    }
    
    
    // MARK: initialization
    public override func viewDidLoad() {
        
        createTextView()
        textEditorView.lnv_setUpLineNumberView()
        
        if let outlineView = outlineViewController?.view {
            
            showOutline(false, animated: false)
            self.view.addSubview(outlineView)
        }
        
        // create mouse area to show/hide the outline
        let rect = NSRect(x: 0, y: 0, width: 100, height: 100)
        outlineMouseTrackingArea = NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.view.addTrackingArea(outlineMouseTrackingArea!)
    }
    
    private func createTextView() {
    
        // 1. create text storage that backs the editor
        //TODO: hook font up to settings/preferences
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
        let attributes = [NSAttributedString.Key.font : monospaceFont]
        //TODO: hook string up to opened file
        let string = ""
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        textStorage = NSTextStorage()
        textStorage.font = monospaceFont
        textStorage.delegate = self
        textStorage.append(attributedString)
        
        let scrollViewRect = view.bounds
        
        // 2. create the layout manager
        layoutManager = TextEditorLayoutManager()
        layoutManager?.allowsNonContiguousLayout = true
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
        
        // word-wrap
        textContainer.widthTracksTextView = true
        
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
        textEditorView.typingAttributes = attributes
        
        // 7. assemble
        scrollView.documentView = textEditorView
        
        view.addSubview(scrollView)
    }
    
    // MARK: - Outline View
    private func showOutline(_ show: Bool, animated: Bool) {
        
        //TODO: add animation
        
        guard let outlineView = outlineViewController?.view else {
            
            return
        }
        
        outlineView.isHidden = !show
    }
    
    public override func mouseEntered(with event: NSEvent) {
        
        showOutline(true, animated: true)
    }
    
    public override func mouseExited(with event: NSEvent) {
        
//        showOutline(false, animated: true)
    }
    
    // MARK: - SyntaxHighlighterDelegate
    func invalidateRanges(invalidRanges: [NSRange]) {
        
        guard let layoutManager = self.layoutManager else {
            return
        }

        for invalidRange in invalidRanges {

            layoutManager.invalidateDisplay(forCharacterRange: invalidRange)
        }
    }
    
    func willAddAttributes(_ SyntaxHighlighter: SyntaxHighligher) {
        
        ignoreProcessEditing = true
    }
    
    func didAddAttributes(_ SyntaxHighlighter: SyntaxHighligher) {
        
        ignoreProcessEditing = false
    }
    
    // MARK: - NSTextStorageDelegate
    public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        guard ignoreProcessEditing == false else {
            return
        }
        
        syntaxHighlighter?.highlight(editedRange: editedRange, changeInLength: delta, textStorage: textStorage)
        outlineModel?.outline(textStorage: textStorage)
    }
    
    // MARK: - OutlineViewControllerDelegate
    func removeTextGroup(_ textGroup: TextGroup) {
        
        let range = outlineModel?.range(of: textGroup)
        print("range of \(textGroup.title): \(String(describing: range))")
    }
    
    func insertTextGroup(_ textGroup: TextGroup, in: TextGroup, at: Int) {
        
        //TODO: implement
    }
}
