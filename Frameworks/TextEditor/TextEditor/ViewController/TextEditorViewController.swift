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
        
        addTestButton()
    }
    
    private func addTestButton() {
        
        let button = NSButton(image: #imageLiteral(resourceName: "elipses"), target: self, action: #selector(buttonAction))
        
        self.view.addSubview(button)
    }
    
    @objc private func buttonAction() {

        collapsedTextGroups = []
        
        let attributes = [NSAttributedString.Key.font : standardFont]
        let attributedString = NSAttributedString(string: demoString, attributes: attributes)
        textStorage.replaceCharacters(in: textStorage.string.maxNSRange, with: attributedString)
        
//        print("collapsedGroups:")
//        for collapsedTextGroup in collapsedTextGroups {
//            print(collapsedTextGroup.title)
//        }
//        print("")
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
        
        
        //TODO: figure out how to handle deletion of a collapse text group titile
        // eg: user collapses a group, then highlights the title and deletes it
        // should the content of the textgroup be deleted? if so, figure out how to do it
        // should the content of the textgroup be expaned? if so, figure out how to do it
        
        //TODO: figure out what shold happen when deleting '#' in a collapsed title that then makes that gorup consume a group underneath it
        // should it auto-expand when deleting '#'?
        
        outlineModel?.outline(textStorage: textStorage) {
            
            DispatchQueue.main.async {
                
                self.validateCollapsedTextGroups()
            }
        }
        
        if rulerView != nil {
            
            rulerView.needsDisplay = true
        }
    }
    
    private func expandAllTextGroups() {

        for collapsedTextGroup in collapsedTextGroups {

            guard let iterator = outlineModel?.textGroups.first?.createIterator() else {
                continue
            }
            
            var iteratedTextGroup: TextGroup? = iterator.next()
            var correspondingTextGroup: TextGroup? = nil
            while iteratedTextGroup != nil {
                
                var iteratedTitle = iteratedTextGroup?.title
                iteratedTitle?.removeLast() // removing the text attachment on the end
                let collapsedTitle = String(collapsedTextGroup.title)
                if iteratedTitle == collapsedTitle {
                    correspondingTextGroup = iteratedTextGroup
                }
                
                iteratedTextGroup = iterator.next()
            }
            
            if let correspondingTextGroup = correspondingTextGroup {
                
                expandTextGroup(textGroup: correspondingTextGroup, invalidateDisplay: true)
            }
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
    private func validateCollapsedTextGroups() {
        //TODO: fix for textAttachment
        return
        var invalidTextGroups: [TextGroup] = []
        
        //TODO: use text group iterator
        //currently this only iterates over the base level of text groups
        for collapsedTextGroup in collapsedTextGroups {
            
            var stillExists = false
            for textGroup in outlineModel?.textGroups ?? [] {
                
                if textGroup.hasSameChildrenTitles(as: collapsedTextGroup) {
                    stillExists = true
                    break
                }
            }
            
            if stillExists == false {
                invalidTextGroups.append(collapsedTextGroup)
            }
        }
        
        for invalidTextGroup in invalidTextGroups {
            
            guard let invalidTextGroupIndex = collapsedTextGroups.firstIndex(of: invalidTextGroup) else {
                continue
            }
            
            collapsedTextGroups.remove(at: invalidTextGroupIndex)
        }
    }
    
    func markerClicked(_ marker: TextGroupMarker) {
        
        
        guard let correspondingTextGroup1 = outlineModel?.textGroup(at: marker.token.range.location) else {
            return
        }
        
        expandAllTextGroups()
        
        guard let iterator = outlineModel?.textGroups.first?.parentTextGroup?.createIterator() else {
            return
        }
        
        var iteratedTextGroup: TextGroup? = iterator.next()
        var correspondingTextGroup: TextGroup! = nil
        while iteratedTextGroup != nil {
            
            if iteratedTextGroup?.title == correspondingTextGroup1.title {
                correspondingTextGroup = iteratedTextGroup
                break
            }
            
            iteratedTextGroup = iterator.next()
        }
        
        guard correspondingTextGroup != nil else {
            return
        }
        
//        guard let correspondingTextGroup = outlineModel?.textGroup(at: marker.token.range.location) else {
//            return
//        }
        
        guard let range = collapsedTextGroupRange(correspondingTextGroup) else {
            return
        }
        
        
//        let savedCollapsedTextGroups = collapsedTextGroups
        
        
        
        
        var textGroupIsCollapsed = false
        var indexOfCollapsedTextGroup: Int? = nil
        for collapsedTextGroup in collapsedTextGroups {

            //TODO: fix this - comparing titles is not always valid
            let range = correspondingTextGroup.title.startIndex..<correspondingTextGroup.title.index(before: correspondingTextGroup.title.endIndex)
            let correspondingTextGroupTitle = correspondingTextGroup.title[range]
            if correspondingTextGroupTitle == collapsedTextGroup.title {
                textGroupIsCollapsed = true
                indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex(of: collapsedTextGroup)
                break
            }
        }
        
        guard textGroupIsCollapsed || range.length > 1 else {
            return
        }
        
        let savedCollapsedTextGroupsTitles = collapsedTextGroups.map { (textGroup) -> String in
            return textGroup.title
        }
        
        if textGroupIsCollapsed {
            
            guard let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup else {
                return
            }
            self.collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            
            expandTextGroup(textGroup: correspondingTextGroup)
        }
        else {
            
            collapseTextGroup(correspondingTextGroup)
        }
        
        
        for collapsedTextGroupTitle in savedCollapsedTextGroupsTitles {
            
            guard let iterator = outlineModel?.textGroups.first?.createIterator() else {
                continue
            }
            
            var iteratedTextGroup: TextGroup? = iterator.next()
            var correspondingTextGroup: TextGroup? = nil
            while iteratedTextGroup != nil {
                
                if iteratedTextGroup?.title == collapsedTextGroupTitle {
                    correspondingTextGroup = iteratedTextGroup
                    break
                }
                
                iteratedTextGroup = iterator.next()
            }
            
            
            if let correspondingTextGroup = correspondingTextGroup {
                
                collapseTextGroup(correspondingTextGroup)
            }
        }
        
        self.invalidateRanges(invalidRanges: [range])
    }
    
    // MARK: collapse text group
    private func collapsedTextGroupRange(_ textGroup: TextGroup) -> NSRange? {
       
        guard let iterator = textGroup.parentTextGroup?.createIterator() else {
            return nil
        }
        
        var iteratedTextGroup: TextGroup? = iterator.next()
        var correspondingTextGroup: TextGroup? = nil
        while iteratedTextGroup != nil {
            
            if iteratedTextGroup?.title == textGroup.title {
                correspondingTextGroup = iteratedTextGroup
                break
            }
            
            iteratedTextGroup = iterator.next()
        }
        
        
        
        guard let locationOfToken = correspondingTextGroup?.token?.range.location,
              let lengthOfToken = correspondingTextGroup?.token?.range.length else {
                return nil
        }
        
        let location = locationOfToken + lengthOfToken
        
        let endIndex: Int
        // get next text group that is not a child,
        if let nextTextGroup = outlineModel?.nextTextGroupWithEqualOrHigherPriority(after: textGroup),
           let token = nextTextGroup.token {
            
            endIndex = token.range.location - 1
        }
        // if no next text group, then use end of string
        else {
            
            endIndex = textStorage.string.maxNSRange.length
        }
        
        let range = NSRange(location: location, length: endIndex-location)
    
        return range
    }
    
    private func collapseTextGroup(_ textGroup: TextGroup) {
        
        guard let range = collapsedTextGroupRange(textGroup) else {
            return
        }
        let location = range.location
        let endIndex = (location + range.length)
        
        let string = textStorage.attributedSubstring(from: range)
        let attachment = TestTextAttachment(data: nil, ofType: "someType")
        attachment.image = #imageLiteral(resourceName: "elipses")
        attachment.bounds = NSRect(x: 1, y: -1, width: 15, height: 10)

        attachment.myString = string

        let attachmentString = NSAttributedString(attachment: attachment)

        self.textStorage.replaceCharacters(in: NSRange(location: location, length: endIndex-location), with: attachmentString)
        
        var alreadyInArray = false
        for collapsedTextGroup in collapsedTextGroups {
            
            if collapsedTextGroup.hasSameChildrenTitles(as: textGroup) {
                
                alreadyInArray = true
            }
        }
        
        if !alreadyInArray {
            
            collapsedTextGroups.append(textGroup)
        }
        
        self.invalidateRanges(invalidRanges: [range])
    }
    
    private func recollapseTextGroups() {
        
        for collapsedTextGroup in collapsedTextGroups {
            collapseTextGroup(collapsedTextGroup)
        }
    }
    
    //MARK: expand text group
    private func expandTextGroup(textGroup: TextGroup, invalidateDisplay: Bool = true) {
        
        //get the textattachment
        guard let token = textGroup.token else {
            return
        }
        
        
        //TODO: the location is either -1 or not. figure out why. and clean it up
        // -1 when clicking on ruler view
        // 0 when called from expandAllGroups
        let attributeLocation = (token.range.location + token.range.length) - 1 // -1 becuase the textAttachment gets included in the token
        guard let attachment = textStorage.attribute(.attachment, at: attributeLocation, effectiveRange: nil) as? TestTextAttachment else {
            return
        }
        //
        
        let stringInAttachment = attachment.myString
        
        let attributeRange = NSRange(location: attributeLocation, length: 1)
        textStorage.replaceCharacters(in: attributeRange, with: stringInAttachment)
        let invalidRange = NSRange(location: attributeRange.location, length: stringInAttachment.string.maxNSRange.length)
        
        if invalidateDisplay {
            self.invalidateRanges(invalidRanges: [invalidRange])
        }
    }
}
