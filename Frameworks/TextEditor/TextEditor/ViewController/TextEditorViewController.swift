//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

public class TextEditorViewController: NSViewController, NSTextViewDelegate, NSTextStorageDelegate, TestRulerViewDelegate, IgnoreProcessingDelegate, CollapsingTranslatorDelegate, OutlineViewControllerDelegate {
    
    // MARK: - Public
    public var delegate: TextEditorViewControllerDelegate? = nil
    
    // MARK: - Properties
    var textEditorView: TextEditorView!
    var textStorage: NSTextStorage!
    var layoutManager: TextEditorLayoutManager? = nil
    var textContainer: NSTextContainer? = nil
    var rulerView: TestRulerView! = nil
    var settings: Settings = Settings()
    var syntaxParser: SyntaxParser? = nil
    var syntaxHighlighter: SyntaxHighligher? = nil
    // used to prevent infinite loop. during processEditing, syntaxHighlighting and expanding/collapsing cause another processEditing call
    var ignoreProcessEditing = false
    var outlineModel: OutlineModel? = nil {
        
        didSet {
            
            if let textStorage = self.textStorage {
                
                outlineModel?.outline(textStorage: textStorage)
            }
        }
    }
    var outlineViewController: OutlineViewController? = nil
    var outlineMouseTrackingArea: NSTrackingArea? = nil
    var collapsingTranslator: CollapsingTranslator? = nil
    
    // TODO: change every object that holds onto language into a getter that pulls it from a common location
    // in order to handle the user changing the language
    let language = LanguageFactory().createLanguage(LanguageFactory.defaultLanguage)
    
    // MARK: - Constructors
    public static func createInstance(delegate: TextEditorViewControllerDelegate) -> TextEditorViewController? {
        
        let bundle = Bundle(for: TextEditorViewController.self)
        let storyboardName = String(describing: TextEditorViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
        viewController?.delegate = delegate
        
        return viewController
    }

    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        syntaxParser = SyntaxParser(language: language)
        
        guard let syntaxParser = syntaxParser else {
             return
        }
        
        syntaxHighlighter = SyntaxHighligher(syntaxParser: syntaxParser)
        syntaxHighlighter?.delegate = self
        
        collapsingTranslator = CollapsingTranslator(delegate: self, ignoreProcessingDelegate: self)
    }
    
    // MARK: initialization
    public override func viewDidLoad() {
        
        createTextView()
        
        outlineViewController = OutlineViewController.createInstance(delegate: self, collapsingTranslator: collapsingTranslator)
        outlineModel = OutlineModel(language: language, delegate: outlineViewController)
        outlineViewController?.model = outlineModel
        self.delegate?.presentSideboard(viewController: outlineViewController!)
        //        if let outlineView = outlineViewController?.view {
        //
        ////            showOutline(false, animated: false)
        //            showOutline(true, animated: false)
        //            self.view.addSubview(outlineView)
        //        }

        
        rulerView = TestRulerView(scrollView: textEditorView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
        rulerView.clientView = textEditorView
        rulerView.delegate = self
        // TODO: change every object that holds onto language into a getter that pulls it from a common location
        // in order to handle the user changing the language
        rulerView.language = LanguageFactory().createLanguage(LanguageFactory.defaultLanguage)
        textEditorView.enclosingScrollView?.verticalRulerView = rulerView
        
        
        // create mouse area to show/hide the outline
        let rect = NSRect(x: 0, y: 0, width: 100, height: 100)
        outlineMouseTrackingArea = NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.view.addTrackingArea(outlineMouseTrackingArea!)
        
//        addTestButton()
    }
    
    private func addTestButton() {
        
        let button = NSButton(image: #imageLiteral(resourceName: "elipses"), target: self, action: #selector(buttonAction))
        
        self.view.addSubview(button)
    }
    
    @objc private func buttonAction() {

        self.invalidateRanges(invalidRanges: [self.textStorage.string.maxNSRange])
    }
    
    private func createTextView() {
    
        // 1. create text storage that backs the editor
        let attributes = [NSAttributedString.Key.font : settings.standardFont]
        
        textStorage = NSTextStorage()
        textStorage.font = settings.standardFont
        textStorage.delegate = self
        
        DocumentOpener().string { (string) in
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            self.textStorage.append(attributedString)
        }
        
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
        textEditorView.delegate = self
        
        textEditorView.enclosingScrollView?.autohidesScrollers = true
        
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
        
        //showOutline(true, animated: true)
    }
    
    public override func mouseExited(with event: NSEvent) {
        
        //showOutline(false, animated: true)
    }
    
    // MARK: - IgnoreProcessingDelegate
    var previousIgnoreProcessEditing = false
    func ignoreProcessing(ignore: Bool) {
        
        if ignore {
            
            previousIgnoreProcessEditing = ignoreProcessEditing
            ignoreProcessEditing = true
        }
        else {
            
            ignoreProcessEditing = previousIgnoreProcessEditing
        }
    }
    
    // MARK: - CollapsingTranslatorDelegate
    func invalidateRanges(invalidRanges: [NSRange]) {
        
        guard let layoutManager = self.layoutManager else {
            return
        }

        for invalidRange in invalidRanges {

            layoutManager.invalidateDisplay(forCharacterRange: invalidRange)
        }
    }
    
    // MARK: - NSTextStorageDelegate
    var invalidRangesSinceLastEditing: [NSRange] = []
    var editingValuesSinceLastParsing: EditingValues? = nil
    
    private var workItem: DispatchWorkItem? = nil
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        guard ignoreProcessEditing == false else {
            return
        }
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            let stringCopy = NSMutableAttributedString(attributedString: self.textStorage)
            
            self.outlineModel?.updateTextGroups(from: textStorage, workItem: newWorkItem)
            
            guard let translations = self.collapsingTranslator?.calculateTranslations(string: stringCopy, collapsedTextGroups: self.collapsedTextGroups, outlineModel: self.outlineModel, editedRange: editedRange, delta: delta, editingValuesSinceLastProcess: self.editingValuesSinceLastParsing, invalidRangesSinceLastProcess: self.invalidRangesSinceLastEditing) else {
                return
            }
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            let editingRangeSinceLastParsing =  self.editingValuesSinceLastParsing?.editedRange.union(translations.editingValues.editedRange) ?? translations.editingValues.editedRange
            let editingDeltaSinceLastParsing = (self.editingValuesSinceLastParsing?.delta ?? 0) + translations.editingValues.delta
            self.editingValuesSinceLastParsing = EditingValues(editedRange: editingRangeSinceLastParsing, delta: editingDeltaSinceLastParsing)
            
            self.invalidRangesSinceLastEditing.append(contentsOf: translations.invalidRanges)
            
            self.outlineModel?.outline(textStorage: stringCopy)
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            guard let editingValues = self.editingValuesSinceLastParsing else {
                return
            }
            
            self.syntaxHighlighter?.highlight(editedRange: editingValues.editedRange, changeInLength: editingValues.delta, string: stringCopy, workItem: newWorkItem) { invalidRangesForHighlighting in

                var invalidRanges = self.invalidRangesSinceLastEditing
                invalidRanges.append(contentsOf: invalidRangesForHighlighting)

                self.editingValuesSinceLastParsing = nil
                self.invalidRangesSinceLastEditing = []

                self.ignoreProcessing(ignore: true)
                invalidRanges = self.collapsingTranslator?.recollapseTextGroups(string: stringCopy, outlineModel: self.outlineModel, invalidRanges: invalidRanges, collapsedTextGroups: self.collapsedTextGroups) ?? []
                self.ignoreProcessing(ignore: false)

                DispatchQueue.main.async {
                    
                    guard newWorkItem.isCancelled == false else {
                        return
                    }
                    
                    let selectedRange = self.textEditorView.selectedRange()
                    self.ignoreProcessEditing = true
                    self.textStorage.setAttributedString(stringCopy)
                    self.textEditorView.setSelectedRange(selectedRange)
                    self.ignoreProcessEditing = false
                    self.invalidateRanges(invalidRanges: invalidRanges)
                    if self.rulerView != nil {
                        self.rulerView.needsDisplay = true //TODO: re-write testRulerView to calculate line #s with collapsedGroups
                    }
                    
                    newWorkItem = nil
                }
            }
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
        
        //TODO: prevent editing inside collapsed groups. but still allow editing the entire group (a selection that includes the collapsed group and deleting or something)
        //TODO: validateCollapsedTextGroups()
    }
    
    // MARK: - etc.
    var collapsedTextGroups: [TextGroup] = []
//    private func validateCollapsedTextGroups() {
//        //TODO: fix for textAttachment
//        return
//        var invalidTextGroups: [TextGroup] = []
//
//        //TODO: use text group iterator
//        //currently this only iterates over the base level of text groups
//        for collapsedTextGroup in collapsedTextGroups {
//
//            var stillExists = false
//            for textGroup in outlineModel?.textGroups ?? [] {
//
//                if textGroup.hasSameChildrenTitles(as: collapsedTextGroup) {
//                    stillExists = true
//                    break
//                }
//            }
//
//            if stillExists == false {
//                invalidTextGroups.append(collapsedTextGroup)
//            }
//        }
//
//        for invalidTextGroup in invalidTextGroups {
//
//            guard let invalidTextGroupIndex = collapsedTextGroups.firstIndex(of: invalidTextGroup) else {
//                continue
//            }
//
//            collapsedTextGroups.remove(at: invalidTextGroupIndex)
//        }
//    }
    
    func markerClicked(_ marker: TextGroupMarker) {
        
        MarkerClickHandler.markerClicked(marker, outlineModel: self.outlineModel, textStorage: self.textStorage, collapsedTextGroups: &self.collapsedTextGroups, collapsingTranslator: self.collapsingTranslator, rulerView: self.rulerView, ignoreProcessingDelegate: self)
    }
    
    // MARK: - OutlineViewControllerDelegate    
    func documentString() -> NSMutableAttributedString? {
        
        return textStorage
    }
    
    func string(for textGroup: TextGroup, outlineModel: OutlineModel?) -> NSAttributedString? {
        
        guard let textStorage = textStorage, let range = outlineModel?.range(of: textGroup, in: textStorage) else {
            return nil
        }
        
        let attributedString = textStorage.attributedSubstring(from: range)
        
        let rangeOfLastCharacter = NSRange(location: attributedString.length-1, length: 1)
        
        let lastCharacter = attributedString.attributedSubstring(from: rangeOfLastCharacter)
        
        if lastCharacter.string != "\n" {
            
            return attributedString.appended("\n")
        }
        
        return attributedString
    }
    
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int, outlineModel: OutlineModel?) {
        
        let textGroupInserter: TextGroupInserter
        
        if index == 0 {
            
            textGroupInserter = ZeroIndexTextGroupInserter()
        }
        else {
            
            textGroupInserter = PositiveIndexTextGroupInserter()
        }
        
        let adjacentTextGroup = textGroupInserter.adjacentTextGroup(textGroups: textGroup.textGroups, index: index)
        
        guard let textStorage = textStorage, let rangeOfAdjacentTextGroup = outlineModel?.range(of: adjacentTextGroup, in: textStorage) else {
            return
        }
        
        let locationToInsert = textGroupInserter.locationToInsert(adjacentTextGroupRange: rangeOfAdjacentTextGroup)
        
        //if inserting string to end of document, and the end of the document is not a newline character. add a new line charachter so the textgorup is not appended inside the last textgroup
        
        var attributedStringToInsert = attributedString
        if locationToInsert == textStorage.string.count {
            
            if textStorage.string.suffix(1) != "\n" {
                
                attributedStringToInsert = attributedString.prepended("\n")
            }
        }
        
        textStorage.insert(attributedStringToInsert, at: locationToInsert)
    }
    
    func removeTextGroup(_ textGroup: TextGroup, outlineModel: OutlineModel?) {
        
        guard let textStorage = textStorage, let range = outlineModel?.range(of: textGroup, in: textStorage) else {
            return
        }
        
        textStorage.replaceCharacters(in: range, with: "")
        outlineModel?.reCalculateTextGroups(replacingRange: range, with: "")
    }
    
    func beginUpdates() {
        textStorage?.beginEditing()
    }
    
    func endUpdates() {
        textStorage?.endEditing()
    }
}
