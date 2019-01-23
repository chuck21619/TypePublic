//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation


//TODO: hook font up to settings/preferences
let hiddenFontSize: CGFloat = 0.00001
let hiddenFont = NSFont(name: "Menlo", size: hiddenFontSize) ?? NSFont.systemFont(ofSize: hiddenFontSize)
let standardFontSize: CGFloat = 11
let standardFont = NSFont(name: "Menlo", size: standardFontSize) ?? NSFont.systemFont(ofSize: standardFontSize)

public class TextEditorViewController: NSViewController, NSTextViewDelegate, NSTextStorageDelegate, OutlineViewControllerDelegate, TestRulerViewDelegate, IgnoreProcessingDelegate, CollapsingTranslatorDelegate {
    
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
    
    var collapsingTranslator: CollapsingTranslator? = nil
    
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
        
        // TODO: change every object that holds onto language into a getter that pulls it from a common location
        // in order to handle the user changing the language
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
        
        collapsingTranslator = CollapsingTranslator(delegate: self, ignoreProcessingDelegate: self)
    }
    
    var rulerView: TestRulerView! = nil
    // MARK: initialization
    public override func viewDidLoad() {
        
        createTextView()
        
        rulerView = TestRulerView(scrollView: textEditorView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
        rulerView.clientView = textEditorView
        rulerView.delegate = self
        // TODO: change every object that holds onto language into a getter that pulls it from a common location
        // in order to handle the user changing the language
        rulerView.language = LanguageFactory().createLanguage(LanguageFactory.defaultLanguage)
        textEditorView.enclosingScrollView?.verticalRulerView = rulerView
        
        if let outlineView = outlineViewController?.view {
            
            showOutline(false, animated: false)
            self.view.addSubview(outlineView)
        }
        
        // create mouse area to show/hide the outline
        let rect = NSRect(x: 0, y: 0, width: 100, height: 100)
        outlineMouseTrackingArea = NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.view.addTrackingArea(outlineMouseTrackingArea!)
        
        addTestButton()
    }
    
    private func addTestButton() {
        
        let button = NSButton(image: #imageLiteral(resourceName: "elipses"), target: self, action: #selector(buttonAction))
        
        self.view.addSubview(button)
    }
    
    @objc private func buttonAction() {

        self.invalidateRanges(invalidRanges: [self.textStorage.string.maxNSRange])
    }
    
    let demoString = "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else"
    
    private func createTextView() {
    
        // 1. create text storage that backs the editor
        let attributes = [NSAttributedString.Key.font : standardFont]
        //TODO: hook string up to opened file
        let string = demoString
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        textStorage = NSTextStorage()
        textStorage.font = standardFont
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
        textEditorView.delegate = self
        
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
        
        showOutline(false, animated: true)
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
                invalidRanges = self.collapsingTranslator?.recollapseTextGroups(string: stringCopy, outlineModel: self.outlineModel, invalidRanges: invalidRanges, collapsedTextGroups: &self.collapsedTextGroups) ?? []
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
    
    // MARK: - OutlineViewControllerDelegate
    // TODO: these operations should not be done by the viewController?
    // maybe the delegate of the outlineVC could be something else?
    func removeTextGroup(_ textGroup: TextGroup) {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return
        }
        
        textStorage.replaceCharacters(in: range, with: "")
    }
    
    // MARK: - etc.
    func title(for textGroup: TextGroup) -> NSAttributedString? {
        
        guard let range = outlineModel?.range(of: textGroup) else {
            return nil
        }
        
        let attributedString = textStorage.attributedSubstring(from: range)
        
        let rangeOfLastCharacter = NSRange(location: attributedString.length-1, length: 1)
        
        let lastCharacter = attributedString.attributedSubstring(from: rangeOfLastCharacter)
        
        if lastCharacter.string != "\n" {
            
            // adds a newline character
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
    
            let insertString = NSAttributedString(string: "\n")
            mutableAttributedString.append(insertString)
    
            return mutableAttributedString
        }
        
        return attributedString
    }
    
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int) {
        
        let textGroupInserter: TextGroupInserter
        
        if index == 0 {
            
            textGroupInserter = ZeroIndexTextGroupInserter()
        }
        else {
            
            textGroupInserter = PositiveIndexTextGroupInserter()
        }
        
        let adjacentTextGroup = textGroupInserter.adjacentTextGroup(textGroups: textGroup.textGroups, index: index)
        
        guard let rangeOfAdjacentTextGroup = outlineModel?.range(of: adjacentTextGroup) else {
            return
        }
        
        let locationToInsert = textGroupInserter.locationToInsert(adjacentTextGroupRange: rangeOfAdjacentTextGroup)
        
        textStorage.insert(attributedString, at: locationToInsert)
    }
    
    func beginUpdates() {
        self.textStorage.beginEditing()
    }
    
    func endUpdates() {
        self.textStorage.endEditing()
    }
    
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
        
        ignoreProcessEditing = true
        
        outlineModel?.updateTextGroups(from: textStorage)
        
        guard let textGroup = outlineModel?.textGroup(at: marker.token.range.location) else {
            return
        }
        
        var textGroupIsCollapsed = false
        
        for collapsedTextGroup in collapsedTextGroups {
            
            if collapsedTextGroup.title == textGroup.title {
                textGroupIsCollapsed = true
            }
        }
        
        if textGroupIsCollapsed {
            
            self.collapsingTranslator?.expandTextGroup(string: self.textStorage, textGroup: textGroup)
            outlineModel?.updateTextGroups(from: textStorage)
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            
            //re-collapse all groups inside of it that were collapsed
            for childTextGroup in updatedTextGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if collapsedTextGroup.title == childTextGroup.title {
                        
                        self.collapsingTranslator?.collapseTextGroup(string: textStorage, updatedTextGroup, outlineModel: self.outlineModel, collapsedTextGroups: &self.collapsedTextGroups)
                        outlineModel?.updateTextGroups(from: textStorage)
                    }
                }
            }
            
            let indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex { (collapsedTextGroup) -> Bool in
                collapsedTextGroup.title == textGroup.title
            }
            
            if let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup {
                collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            }
        }
        else {
            
            //expand all groups inside of it that are collapsed
            for childTextGroup in textGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if childTextGroup.title == collapsedTextGroup.title {
                        
                        self.collapsingTranslator?.expandTextGroup(string: self.textStorage, textGroup: childTextGroup)
                        outlineModel?.updateTextGroups(from: textStorage)
                    }
                }
            }
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            self.collapsingTranslator?.collapseTextGroup(string: textStorage, updatedTextGroup, outlineModel: self.outlineModel, collapsedTextGroups: &self.collapsedTextGroups)
            outlineModel?.updateTextGroups(from: textStorage)
        }
        
        rulerView.needsDisplay = true
        
        ignoreProcessEditing = false
    }
}
