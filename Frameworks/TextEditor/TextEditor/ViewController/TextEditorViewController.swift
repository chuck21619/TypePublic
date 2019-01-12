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

        self.invalidateRanges(invalidRanges: [self.textStorage.string.maxNSRange])
    }
    
    //let demoString = "1\n2\n3\n4\n5\n\n6\n7\n8\n9\n0\n\n11\n12\n13\n14\n15\n\n16\n17\n18\n19\n10\n\n21\n22\n23\n24\n25\n\n26\n27\n28\n29\n20\n\n31\n32\n33\n34\n35\n\n36\n37\n38\n39\n30\n\n41\n42\n43\n44\n45\n\n46\n47\n48\n49\n40\n"
    
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
    
    var previousIgnoreProcessEditing = false
    func willAddAttributes(_ SyntaxHighlighter: SyntaxHighligher) {
        
        previousIgnoreProcessEditing = ignoreProcessEditing
        ignoreProcessEditing = true
    }
    
    func didAddAttributes(_ SyntaxHighlighter: SyntaxHighligher) {
        
        ignoreProcessEditing = previousIgnoreProcessEditing
    }
    
    // MARK: - NSTextStorageDelegate
    var adjustedEditedRangeSinceLastEditing: NSRange? = nil
    var adjustedDeltaSinceLastEditing: Int? = nil
    var invalidRangesSinceLastEditing: [NSRange] = []
    
    private var workItem: DispatchWorkItem? = nil
    
//    public func textStorage(_ textStorage: NSTextStorage, WillProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        <#code#>
//    }
    
    var soeInt = 0
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        soeInt += 1
        print(soeInt)
        
        guard ignoreProcessEditing == false else {
            return
        }
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem {
            
            let stringCopy = NSMutableAttributedString(attributedString: self.textStorage)
            
            //a non-nil lastEditing var means they have been expanded by a previous processEditing call
            let translations: (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRanges: [NSRange])
            if self.adjustedDeltaSinceLastEditing == nil {
                
                let previousIgnoreProcessEditing = self.ignoreProcessEditing
                self.ignoreProcessEditing = true
                
                //TODO: issue - nslayoutmanager: Thread Safety of NSLayoutManager
                translations = self.expandAllTextGroups(string: stringCopy, editedRange: editedRange, delta: delta)
                self.ignoreProcessEditing = previousIgnoreProcessEditing
            }
            else {
                
                //TODO: figure out how to calculate this correctly
                translations = (adjustedEditedRange: editedRange, adjustedDelta: 0, invalidRanges: [])
            }
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            guard let translatedEditedRange1 = translations.adjustedEditedRange,
                  let translatedChangeInLength1 = translations.adjustedDelta else {
                    return
            }
            
            self.adjustedEditedRangeSinceLastEditing = self.adjustedEditedRangeSinceLastEditing?.union(translatedEditedRange1) ?? translatedEditedRange1
            self.adjustedDeltaSinceLastEditing = (self.adjustedDeltaSinceLastEditing ?? 0) + translatedChangeInLength1
            self.invalidRangesSinceLastEditing.append(contentsOf: translations.invalidRanges)
            
            self.outlineModel?.outline(textStorage: stringCopy)
        
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            guard let translatedEditedRange = self.adjustedEditedRangeSinceLastEditing,
                  let translatedChangeInLength = self.adjustedDeltaSinceLastEditing else {
                    return
            }
            
            self.syntaxHighlighter?.highlight(editedRange: translatedEditedRange, changeInLength: translatedChangeInLength, string: stringCopy, workItem: newWorkItem) { invalidRangesForHighlighting in

                var invalidRanges = self.invalidRangesSinceLastEditing
                invalidRanges.append(contentsOf: invalidRangesForHighlighting)

                self.adjustedEditedRangeSinceLastEditing = nil
                self.adjustedDeltaSinceLastEditing = nil
                self.invalidRangesSinceLastEditing = []


                let previousIgnoreProcessEditing = self.ignoreProcessEditing
                self.ignoreProcessEditing = true
                invalidRanges = self.recollapseTextGroups(string: stringCopy, invalidRanges: invalidRanges)
                self.ignoreProcessEditing = previousIgnoreProcessEditing

                DispatchQueue.main.async {
                    
                    let selectedRange = self.textEditorView.selectedRange()
                    self.ignoreProcessEditing = true
                    self.textStorage.setAttributedString(stringCopy)
                    self.textEditorView.setSelectedRange(selectedRange)
                    self.ignoreProcessEditing = false
                    self.invalidateRanges(invalidRanges: invalidRanges)
                    if self.rulerView != nil {
                        self.rulerView.needsDisplay = true //TODO: re-write testRulerView to calculate line #s with collapsedGroups
                    }
                }
            }
        
            newWorkItem = nil
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
        
        
        //TODO: figure out what shold happen when deleting '#' in a collapsed title that then makes that gorup consume a group underneath it
        // should it auto-expand when deleting '#'?
        
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
    
    // MARK: - TestRulerViewDelegate
    private func expandAllTextGroups(string: NSMutableAttributedString, editedRange: NSRange? = nil, delta: Int? = nil) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRanges: [NSRange]) {
        
        var adjustedEditedRange = editedRange
        var adjustedDelta = delta
        var invalidRanges: [NSRange] = []
        
        for collapsedTextGroup in collapsedTextGroups {
            
            outlineModel?.updateTextGroups(from: string)
            
            guard let iterator = outlineModel?.parentTextGroup.createIterator() else {
                continue
            }
            
            var iteratedTextGroup: TextGroup? = iterator.next()
            var correspondingTextGroup: TextGroup? = nil
            while iteratedTextGroup != nil {
                
                if iteratedTextGroup?.title == collapsedTextGroup.title {
                    correspondingTextGroup = iteratedTextGroup
                    break
                }
                
                iteratedTextGroup = iterator.next()
            }
            
            if let correspondingTextGroup = correspondingTextGroup {
                
                let adjustments = expandTextGroup(string: string, textGroup: correspondingTextGroup, invalidateDisplay: false, editedRange: adjustedEditedRange, delta: adjustedDelta)
                
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
            
            expandTextGroup(string: self.textStorage,textGroup: textGroup)
            outlineModel?.updateTextGroups(from: textStorage)
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            
            //re-collapse all groups inside of it that were collapsed
            for childTextGroup in updatedTextGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if collapsedTextGroup.title == childTextGroup.title {
                        
                        collapseTextGroup(string: self.textStorage, childTextGroup)
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
                        
                        expandTextGroup(string: self.textStorage, textGroup: childTextGroup)
                        outlineModel?.updateTextGroups(from: textStorage)
                    }
                }
            }
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            collapseTextGroup(string: textStorage, updatedTextGroup)
            outlineModel?.updateTextGroups(from: textStorage)
        }
        
        rulerView.needsDisplay = true
        
        ignoreProcessEditing = false
    }
    
    // MARK: collapse text group
    private func collapsedTextGroupRange(string: NSMutableAttributedString, _ textGroup: TextGroup) -> NSRange? {
       
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
            
            endIndex = string.string.maxNSRange.length
        }
        
        let range = NSRange(location: location, length: endIndex-location)
    
        return range
    }
    
    @discardableResult private func collapseTextGroup(string: NSMutableAttributedString, _ textGroup: TextGroup, invalidRanges: [NSRange] = [], recollapsing: Bool = false) -> [NSRange] {
        
        outlineModel?.updateTextGroups(from: string)
        
        var correspondingTextGroup: TextGroup? = nil
        let iterator = outlineModel?.parentTextGroup.createIterator()
        var iteratedTextGroup: TextGroup? = iterator?.next()
        
        while iteratedTextGroup != nil {
            
            if iteratedTextGroup?.title == textGroup.title {
                correspondingTextGroup = iteratedTextGroup
                break
            }
            
            iteratedTextGroup = iterator?.next()
        }
        
        guard correspondingTextGroup != nil else {
            return []
        }
        
        let range: NSRange
        if recollapsing {
            range = outlineModel!.range(of: correspondingTextGroup!, includeTitle: false)!
        }
        else {
            range = collapsedTextGroupRange(string: string, correspondingTextGroup!)!
        }
        
        let location = range.location
        let endIndex = (location + range.length)
        
        let textGroupString = string.attributedSubstring(from: range)
        let attachment = TestTextAttachment(data: nil, ofType: "someType")
        attachment.image = #imageLiteral(resourceName: "elipses")
        attachment.bounds = NSRect(x: 1, y: -1, width: 15, height: 10)

        attachment.myString = textGroupString

        let attachmentString = NSAttributedString(attachment: attachment)

        string.replaceCharacters(in: NSRange(location: location, length: endIndex-location), with: attachmentString)
        
        
        
        
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
    
    private func recollapseTextGroups(string: NSMutableAttributedString, invalidRanges: [NSRange]) -> [NSRange] {
        
        var adjustedInvalidRanges = invalidRanges
        for collapsedTextGroup in collapsedTextGroups {
            adjustedInvalidRanges = collapseTextGroup(string: string, collapsedTextGroup, invalidRanges: invalidRanges, recollapsing: true)
        }
        
        return adjustedInvalidRanges
    }
    
    //MARK: expand text group
    @discardableResult private func expandTextGroup(string: NSMutableAttributedString, textGroup: TextGroup, invalidateDisplay: Bool = true, editedRange: NSRange? = nil, delta: Int? = nil) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRange: NSRange?) {
        
        //get the textattachment
        guard let token = textGroup.token else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        
        let attributeLocation = (token.range.location + token.range.length)
        let attributeRange = NSRange(location: attributeLocation, length: 1)
        guard let attachment = string.attribute(.attachment, at: attributeLocation, effectiveRange: nil) as? TestTextAttachment else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        //
        
        let stringInAttachment = attachment.myString
        
        string.replaceCharacters(in: NSRange(location: attributeRange.location, length: attributeRange.length), with: stringInAttachment)
        let invalidRange = NSRange(location: attributeRange.location, length: stringInAttachment.string.maxNSRange.length)
        
        if invalidateDisplay {
            print("WHO IS CALLING THIS - needs to be re-written")
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
