//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

public class TextEditorViewController: NSViewController, NSTextViewDelegate, SyntaxHighlighterDelegate, NSTextStorageDelegate, OutlineViewControllerDelegate, TestRulerViewDelegate {
    
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
    }
    
    @objc func buttonAction() {
        
    }
    
    var rulerView: TestRulerView! = nil
    // MARK: initialization
    public override func viewDidLoad() {
        
        createTextView()
//        textEditorView.lnv_setUpLineNumberView()
        
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
        
        showOutline(false, animated: true)
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
        
        if rulerView != nil {
            
            rulerView.needsDisplay = true
        }
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
    
    // MARK: - TestRulerViewDelegate
    var collapsedTextGroups: [TextGroup] = []
    func markerClicked(_ marker: TextGroupMarker) {
        
        //// get range of text group
        /// location
        let location = marker.token.range.location + marker.token.range.length
        /// endIndex
        // get text group
        guard let correspondingTextGroup = outlineModel?.textGroup(at: marker.token.range.location) else {
            return
        }
        
        let endIndex: Int
        // get next text group that is not a child,
        if let nextTextGroup = outlineModel?.nextTextGroupWithEqualOrHigherPriority(after: correspondingTextGroup),
           let token = nextTextGroup.token {

            endIndex = token.range.location
        }
        // if no next text group, then use end of string
        else {

            endIndex = textStorage.string.maxNSRange.length
        }
        
        let range = NSRange(location: location, length: endIndex-location)
        
        guard range.length > 1 else {
            return
        }
        
        let lowerBound = textStorage.string.index(textStorage.string.startIndex, offsetBy: location)
        let upperBound = textStorage.string.index(textStorage.string.startIndex, offsetBy: endIndex)

        
        var textGroupIsCollapsed = false
        var indexOfCollapsedTextGroup: Int? = nil
        for collapsedTextGroup in collapsedTextGroups {
            
            if correspondingTextGroup.hasSameChildrenTitles(as: collapsedTextGroup) {
                textGroupIsCollapsed = true
                indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex(of: collapsedTextGroup)
                break
            }
        }
        
        if textGroupIsCollapsed {
            
            
            
            //        // *********************
            //        // replacing textGroup with textAttachment
            //
            //        let string = String(textStorage.string[lowerBound..<upperBound])
            //        let attachment = TestTextAttachment(data: nil, ofType: "someType")
            //        attachment.image = #imageLiteral(resourceName: "egg-icon")
            //
            //        attachment.myString = string
            //
            //        let attachmentString = NSAttributedString(attachment: attachment)
            //
            //        self.textStorage.replaceCharacters(in: NSRange(location: location, length: endIndex-location), with: attachmentString)
            //        // *********************
            
            
            
            //        // *********************
            //        // changing font of textgroup to 0
            //TODO: hook font up to settings/preferences
            let standardFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
            textStorage.addAttribute(.font, value: standardFont, range: range)
            //        // *********************
            
            if let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup {
                
                collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            }
            
            for textGroup in correspondingTextGroup.textGroups {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if collapsedTextGroup.hasSameChildrenTitles(as: textGroup) {
                        
                        collapseTextGroup(collapsedTextGroup)
                    }
                }
            }
            
//            for textGroup in collapsedTextGroups {
//
//                collapseTextGroup(textGroup)
//            }
        }
        else {
            //TODO: hook font up to settings/preferences
            let size: CGFloat = 0.00001
            let hiddenFont = NSFont(name: "Menlo", size: size) ?? NSFont.systemFont(ofSize: size)
            textStorage.addAttribute(.font, value: hiddenFont, range: range)
            
            collapsedTextGroups.append(correspondingTextGroup)
        }
        
        self.invalidateRanges(invalidRanges: [range])
    }
    
    private func collapseTextGroup(_ textGroup: TextGroup) {
        
        guard let locationOfToken = textGroup.token?.range.location,
              let lengthOfToken = textGroup.token?.range.length else {
            return
        }
        
        let location = locationOfToken + lengthOfToken
        
        let endIndex: Int
        // get next text group that is not a child,
        if let nextTextGroup = outlineModel?.nextTextGroupWithEqualOrHigherPriority(after: textGroup),
            let token = nextTextGroup.token {
            
            endIndex = token.range.location
        }
            // if no next text group, then use end of string
        else {
            
            endIndex = textStorage.string.maxNSRange.length
        }
        
        let range = NSRange(location: location, length: endIndex-location)
        
        let lowerBound = textStorage.string.index(textStorage.string.startIndex, offsetBy: location)
        let upperBound = textStorage.string.index(textStorage.string.startIndex, offsetBy: endIndex)
        
        
        var textGroupIsCollapsed = false
        var indexOfCollapsedTextGroup: Int? = nil
        for collapsedTextGroup in collapsedTextGroups {
            
            if textGroup.hasSameChildrenTitles(as: collapsedTextGroup) {
                textGroupIsCollapsed = true
                indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex(of: collapsedTextGroup)
                break
            }
        }
        
            //TODO: hook font up to settings/preferences
            let size: CGFloat = 0.00001
            let hiddenFont = NSFont(name: "Menlo", size: size) ?? NSFont.systemFont(ofSize: size)
            textStorage.addAttribute(.font, value: hiddenFont, range: range)
        
        
        
        self.invalidateRanges(invalidRanges: [range])
    }
}
