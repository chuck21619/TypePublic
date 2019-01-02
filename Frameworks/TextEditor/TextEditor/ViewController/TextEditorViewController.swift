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
    
    var DOTHETHING = false
    @objc private func buttonAction() {

        DOTHETHING = true
//        collapsedTextGroups = []
//
//        let attributes = [NSAttributedString.Key.font : standardFont]
//        let attributedString = NSAttributedString(string: demoString, attributes: attributes)
//        textStorage.replaceCharacters(in: textStorage.string.maxNSRange, with: attributedString)
        
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
        
        //DispatchQueue.background.async {
        //  invalidRange1 = expandAllGroups() //change expandAllGroups to return invalidRange instead of calling invalidateRange: this means i may need to change how expandAllGroups works because it loops through groups, and depends of each one being expanded in order?
            //i think i can just loop through the groups in descending order(but what about nested collapsed groups?)
            // EDIT: i think i can ignore above comments regarding expandAllGroups and just change the invalidateDisplay bool passed to expandGroup to false (because nested collapses dont actually exist in the text storage, the parent collapsed group will contain an expanded version of its text) - why is that true to begin with? it shouldn't even happen with the current implementation (unless its needed when clicking expand/collapse in the rulerView? that would be extremely inefficient and needs to get fixed if so)
        //  translatedEditedRange = to what it is after expanding all groups
        //  translatedChangeInLength = to what it is after expanding all groups (if user deleted a collapsed group, the changeInLength changes)
        //  invalidRange = syntaxHighlighter?.highlight(editedRange: translatedEditedRange, changeInLength: delta, textStorage: textStorage, workItem: workItem) //return invalidRange instead of calling invalidateDisplay. change mainQueue work from syntaxHighlighter to run on same queue
        //  recollapseTextGroups()
        //  if rulerView != nil {
        //    rulerView.needsDisplay = true //update rulerView to calculate collapsedGroups
        //  }
        //}
        
        DispatchQueue.global().async {
            
            let translations = self.expandAllTextGroups(editedRange: editedRange, delta: delta)
            
            self.outlineModel?.outline(textStorage: textStorage)
            
            guard let translatedEditedRange = translations.adjustedEditedRange,
                  let translatedChangeInLength = translations.adjustedDelta else {
                    return
            }
            
            self.syntaxHighlighter?.highlight(editedRange: translatedEditedRange, changeInLength: translatedChangeInLength, textStorage: textStorage) { invalidRangesForHighlighting in
                
                var invalidRanges = translations.invalidRanges
                invalidRanges.append(contentsOf: invalidRangesForHighlighting)
                
                invalidRanges = self.recollapseTextGroups(invalidRanges: invalidRanges)
                
                DispatchQueue.main.async {
                    
                    self.invalidateRanges(invalidRanges: invalidRanges)
                    if self.rulerView != nil {
                        self.rulerView.needsDisplay = true //update rulerView to calculate collapsedGroups
                    }
                }
            }
            
        }
        
        if DOTHETHING {
            let result = self.expandAllTextGroups(editedRange: editedRange, delta: delta)
            print(result)
        }
        
//        DispatchQueue.main.async {
//
//            self.expandAllTextGroups(editedRange: editedRange, delta: delta)
//
//        }
        //TODO: handle consecutive calls in quick succession: may have to change 'DispatchQueue.background.async' to be in a workItem that can be cancelled()
        
        
//        syntaxHighlighter?.highlight(editedRange: editedRange, changeInLength: delta, textStorage: textStorage)
        
        //TODO: figure out what shold happen when deleting '#' in a collapsed title that then makes that gorup consume a group underneath it
        // should it auto-expand when deleting '#'?
        
//        outlineModel?.outline(textStorage: textStorage) {
//
//            DispatchQueue.main.async {
//
//                self.validateCollapsedTextGroups()
//            }
//        }
//
//        if rulerView != nil {
//
//            rulerView.needsDisplay = true
//        }
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
    private func expandAllTextGroups(editedRange: NSRange? = nil, delta: Int? = nil) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRanges: [NSRange]) {
        
        var adjustedEditedRange = editedRange
        var adjustedDelta = delta
        var invalidRanges: [NSRange] = []
        
        for collapsedTextGroup in collapsedTextGroups {
            
            guard let iterator = outlineModel?.parentTextGroup.createIterator() else {
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
                
                let adjustments = expandTextGroup(textGroup: correspondingTextGroup, invalidateDisplay: false, editedRange: adjustedEditedRange, delta: adjustedDelta)
                
                adjustedEditedRange = adjustments.adjustedEditedRange
                adjustedDelta = adjustments.adjustedDelta
                
                if let invalidRange = adjustments.invalidRange {
                    invalidRanges.append(invalidRange)
                }
            }
        }
        
        return (adjustedEditedRange: adjustedEditedRange, adjustedDelta: adjustedDelta, invalidRanges: [])
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
            
            expandTextGroup(textGroup: textGroup)
            outlineModel?.updateTextGroups(from: textStorage.string)
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            
            //re-collapse all groups inside of it that were collapsed
            for childTextGroup in updatedTextGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if collapsedTextGroup.title == childTextGroup.title {
                        
                        collapseTextGroup(childTextGroup)
                        outlineModel?.updateTextGroups(from: textStorage.string)
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
                        
                        expandTextGroup(textGroup: childTextGroup)
                        outlineModel?.updateTextGroups(from: textStorage.string)
                    }
                }
            }
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            collapseTextGroup(updatedTextGroup)
            outlineModel?.updateTextGroups(from: textStorage.string)
        }
        
        rulerView.needsDisplay = true
        
        ignoreProcessEditing = false
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
    
    @discardableResult private func collapseTextGroup(_ textGroup: TextGroup, invalidRanges: [NSRange] = []) -> [NSRange] {
        
        guard let range = collapsedTextGroupRange(textGroup) else {
            return []
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
        
        
        
        
        /////
        var collapsedGroupRangeNeedsToBeInvalidated = false
        for invalidRange in invalidRanges {
            if invalidRange.intersects(range) {
                collapsedGroupRangeNeedsToBeInvalidated = true
                break
            }
        }
        //
        
        var adjustedInvalidRanges: [NSRange] = []
        for invalidRange in invalidRanges {
            
            var adjustedRange: NSRange? = nil
            let groupRange = range
            
            let invalidStartIndex = invalidRange.location
            let invalidEndIndex = invalidRange.location + invalidRange.length
            let groupStartIndex = groupRange.location
            let groupEndIndex = groupRange.location + groupRange.length
            
            //1
            if invalidStartIndex <= groupStartIndex && invalidEndIndex >= groupEndIndex {
                adjustedRange = NSRange(location: invalidRange.location, length: invalidRange.length - groupRange.length)
            }
            //2
            else if invalidEndIndex <= groupStartIndex {
                adjustedRange = invalidRange
            }
            //3
            else if invalidStartIndex >= groupEndIndex {
                adjustedRange = NSRange(location: invalidRange.location - groupRange.length, length: invalidRange.length)
            }
            //4
            else if invalidStartIndex <= groupStartIndex && invalidEndIndex > groupStartIndex && invalidEndIndex < groupEndIndex {
                guard let overlap = invalidRange.intersection(groupRange)?.length else {
                    continue
                }
                
                adjustedRange = NSRange(location: invalidRange.location, length: invalidRange.length - overlap)
            }
            //5
            else if invalidStartIndex > groupStartIndex && invalidStartIndex < groupEndIndex && invalidEndIndex > groupEndIndex {
                guard let overlap = invalidRange.intersection(groupRange)?.length else {
                    continue
                }
                
                adjustedRange = NSRange(location: invalidRange.location - overlap, length: invalidRange.length - overlap)
            }
            //6
            else if invalidStartIndex >= groupStartIndex && invalidEndIndex <= groupEndIndex {
                adjustedRange = nil
            }
            
            if let adjustedRange = adjustedRange {
                adjustedInvalidRanges.append(adjustedRange)
            }
        }
        
        if collapsedGroupRangeNeedsToBeInvalidated {
            adjustedInvalidRanges.append(range)
        }
        /////
        
        
        
        var alreadyInArray = false
        for collapsedTextGroup in collapsedTextGroups {
            
            if collapsedTextGroup.hasSameChildrenTitles(as: textGroup) {
                
                alreadyInArray = true
            }
        }
        
        if !alreadyInArray {
            
            collapsedTextGroups.append(textGroup)
        }
        
        return adjustedInvalidRanges
//        self.invalidateRanges(invalidRanges: [range])
    }
    
    private func recollapseTextGroups(invalidRanges: [NSRange]) -> [NSRange] {
        
        var adjustedInvalidRanges = invalidRanges
        for collapsedTextGroup in collapsedTextGroups {
            adjustedInvalidRanges = collapseTextGroup(collapsedTextGroup, invalidRanges: invalidRanges)
        }
        
        return adjustedInvalidRanges
    }
    
    //MARK: expand text group
    @discardableResult private func expandTextGroup(textGroup: TextGroup, invalidateDisplay: Bool = true, editedRange: NSRange? = nil, delta: Int? = nil) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRange: NSRange?) {
        
        //get the textattachment
        guard let token = textGroup.token else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        
        let attributeLocation = (token.range.location + token.range.length)-1
        let attributeRange = NSRange(location: attributeLocation, length: 1)
        guard let attachment = textStorage.attribute(.attachment, at: attributeLocation, effectiveRange: nil) as? TestTextAttachment else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        //
        
        let stringInAttachment = attachment.myString
        
        textStorage.replaceCharacters(in: NSRange(location: attributeRange.location, length: attributeRange.length), with: stringInAttachment)
        let invalidRange = NSRange(location: attributeRange.location, length: stringInAttachment.string.maxNSRange.length)
        
        if invalidateDisplay {
            self.invalidateRanges(invalidRanges: [invalidRange])
        }
        
        
        
        var invalidRangeReturnValue: NSRange? = nil
        var deltaReturnValue = delta
        var editedRangeReturnValue = editedRange
        
        if editedRange?.intersection(attributeRange)?.length ?? 0 > 0 {
            
            if let delta = delta {
                deltaReturnValue = (delta - stringInAttachment.string.maxNSRange.length) + 1 //+1 due to the textAttachment
            }
            
            if let editedRange = editedRange {
                let location = editedRange.location
                let length = editedRange.length + stringInAttachment.string.maxNSRange.length
                editedRangeReturnValue = NSRange(location: location, length: length)
            }
        }
        else if editedRange?.location ?? 0 > attributeRange.location, let editedRange = editedRange {
            
            let location = editedRange.location + stringInAttachment.string.maxNSRange.length
            let length = editedRange.length
            editedRangeReturnValue = NSRange(location: location, length: length)
        }
        
        if editedRange?.intersects(attributeRange) == true {
            invalidRangeReturnValue = invalidRange
        }
        
        return (adjustedEditedRange: editedRangeReturnValue, adjustedDelta: deltaReturnValue, invalidRange: invalidRangeReturnValue)
    }
}
