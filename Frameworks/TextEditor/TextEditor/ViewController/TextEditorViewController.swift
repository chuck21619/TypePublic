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
    public weak var delegate: TextEditorViewControllerDelegate? = nil
    
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
    var documentOpener: DocumentOpener!
    var outlineModel: OutlineModel? = nil {
        
        didSet {
            
            if let textStorage = self.textStorage {
                
                outlineModel?.outline(textStorage: textStorage)
            }
        }
    }
    var outlineViewController: OutlineViewController? = nil
    var collapsingTranslator: CollapsingTranslator? = nil
    
    // TODO: change every object that holds onto language into a getter that pulls it from a common location
    // in order to handle the user changing the language
    let language = LanguageFactory().createLanguage(LanguageFactory.defaultLanguage)
    
    // MARK: - Constructors
    public static func createInstance(delegate: TextEditorViewControllerDelegate, documentOpener: DocumentOpener) -> TextEditorViewController? {
        
        let bundle = Bundle(for: TextEditorViewController.self)
        let storyboardName = String(describing: TextEditorViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
        viewController?.documentOpener = documentOpener
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
        outlineModel = OutlineModel(language: language, collapsingTranslator: collapsingTranslator!, delegate: outlineViewController)
        outlineViewController?.model = outlineModel
        self.textStorage(self.textStorage, didProcessEditing: [], range: self.textStorage.string.maxNSRange, changeInLength: 0)
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
        rulerView.collapsingTranslator = collapsingTranslator
        // TODO: change every object that holds onto language into a getter that pulls it from a common location
        // in order to handle the user changing the language
        rulerView.language = LanguageFactory().createLanguage(LanguageFactory.defaultLanguage)
        textEditorView.enclosingScrollView?.verticalRulerView = rulerView
        
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
        
        self.documentOpener.string { (string) in
            
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
    
    var testInt = 0
    private var workItem: DispatchWorkItem? = nil
    let semaphore = DispatchSemaphore(value: 1)
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
//        if collapsingTranslator?.someInt ?? 100000 < CollapsingTranslator.someInt {
//            
//            print("a")
//        }
        
        guard ignoreProcessEditing == false else {
            return
        }
        
        workItem?.cancel()
        var newWorkItem: DispatchWorkItem!
        
        newWorkItem = DispatchWorkItem { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.semaphore.wait()
            let stringCopy = NSMutableAttributedString(attributedString: weakSelf.textStorage)
            weakSelf.semaphore.signal()
            
            guard let translations = weakSelf.collapsingTranslator?.calculateTranslations(string: stringCopy, outlineModel: weakSelf.outlineModel, editedRange: editedRange, delta: delta, editingValuesSinceLastProcess: weakSelf.editingValuesSinceLastParsing, invalidRangesSinceLastProcess: weakSelf.invalidRangesSinceLastEditing) else {
                return
            }
            
            guard newWorkItem.isCancelled == false else {
                return
            }
            
            let editingRangeSinceLastParsing =  weakSelf.editingValuesSinceLastParsing?.editedRange.union(translations.editingValues.editedRange) ?? translations.editingValues.editedRange
            let editingDeltaSinceLastParsing = (weakSelf.editingValuesSinceLastParsing?.delta ?? 0) + translations.editingValues.delta
            weakSelf.editingValuesSinceLastParsing = EditingValues(editedRange: editingRangeSinceLastParsing, delta: editingDeltaSinceLastParsing)
            
            weakSelf.invalidRangesSinceLastEditing.append(contentsOf: translations.invalidRanges)
            
            let semaphore = weakSelf.semaphore
            
            weakSelf.outlineModel?.outline(textStorage: stringCopy) { [weak self] in
                
                guard let weakSelf = self else {
                    
                    print("\(self?.testInt)semaphore released - didprocess (no self)")
                    semaphore.signal()
                    return
                }
                
                print("\(weakSelf.testInt)semaphore request - didprocess (\(Thread.isMainThread ? "main thread" : "background thread"))")
                weakSelf.semaphore.wait()
                
                guard newWorkItem.isCancelled == false else {
                    print("\(weakSelf.testInt)semaphore released - didprocess (work item cancelled)")
                    weakSelf.semaphore.signal()
                    return
                }
                
                guard let editingValues = weakSelf.editingValuesSinceLastParsing else {
                    print("\(weakSelf.testInt)semaphore released - didprocess (no editing values)")
                    weakSelf.semaphore.signal()
                    return
                }
                
                weakSelf.syntaxHighlighter?.highlight(editedRange: editingValues.editedRange, changeInLength: editingValues.delta, string: stringCopy, workItem: newWorkItem) { [weak self] invalidRangesForHighlighting in
                    
                    guard let weakSelf = self else {
                        semaphore.signal()
                        return
                    }
                    
                    var invalidRanges = weakSelf.invalidRangesSinceLastEditing
                    invalidRanges.append(contentsOf: invalidRangesForHighlighting)
                    
                    weakSelf.editingValuesSinceLastParsing = nil
                    weakSelf.invalidRangesSinceLastEditing = []
                    
                    weakSelf.ignoreProcessing(ignore: true)
                    invalidRanges = weakSelf.collapsingTranslator?.recollapseTextGroups(string: stringCopy, outlineModel: weakSelf.outlineModel, invalidRanges: invalidRanges, testValue: "didProcess", testInt: weakSelf.testInt) ?? []
                    weakSelf.ignoreProcessing(ignore: false)
                    
                    
                    print("\(weakSelf.testInt)didProcess - calling main thread")
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        print("\(weakSelf.testInt)didProcess - main thread time")
                        
                        guard let weakSelf = self, newWorkItem.isCancelled == false else {
                            print("\(self?.testInt)semaphore released - didprocess (work item cancelled 2)")
                            semaphore.signal()
                            return
                        }
                        
                        let selectedRange = weakSelf.textEditorView.selectedRange()
                        weakSelf.ignoreProcessEditing = true
                        weakSelf.textStorage.setAttributedString(stringCopy)
                        weakSelf.textEditorView.setSelectedRange(selectedRange)
                        weakSelf.ignoreProcessEditing = false
                        weakSelf.invalidateRanges(invalidRanges: invalidRanges)
                        if weakSelf.rulerView != nil {
                            weakSelf.rulerView.needsDisplay = true //TODO: re-write testRulerView to calculate line #s with collapsedGroups
                        }
                        
                        newWorkItem = nil
                        
                        print("\(weakSelf.testInt)semaphore released - didprocess (completed)")
                        weakSelf.semaphore.signal()
                    }
                }
            }
        }
        
        self.workItem = newWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
        
        //TODO: prevent editing inside collapsed groups. but still allow editing the entire group (a selection that includes the collapsed group and deleting or something)
        //TODO: validateCollapsedTextGroups()
    }
    
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
    
    func markerClicked(_ marker: TextGroupMarker, completion: @escaping ()->()) {
        
        DispatchQueue.global().async {
            
            print("\(self.testInt)semaphore request - markerClick (\(Thread.isMainThread ? "main thread" : "background thread"))")
            self.semaphore.wait()
            MarkerClickHandler.markerClicked(marker, outlineModel: self.outlineModel, textStorage: self.textStorage, collapsingTranslator: self.collapsingTranslator, rulerView: self.rulerView, ignoreProcessingDelegate: self, testInt: self.testInt)
            
            DispatchQueue.main.async {
                //TODO: figure out invalid range
                self.invalidateRanges(invalidRanges: [self.textStorage.string.maxNSRange])
                self.rulerView.needsDisplay = true
                print("\(self.testInt)semaphore released - markerClicked")
                self.semaphore.signal()
                completion()
            }
        }
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
    
    //movedTextGroup = textgroup that was dragNDropped which is resulting in the call. passed to that we can correctly recalculate its range
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int, outlineModel: OutlineModel?, movedTextGroup: TextGroup?) {
        
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
        var addition = 0
        if locationToInsert == textStorage.string.count {
            
            if textStorage.string.suffix(1) != "\n" {
                
                attributedStringToInsert = attributedString.prepended("\n")
                addition = 1
            }
        }
        
        textStorage.insert(attributedStringToInsert, at: locationToInsert)
        
        
        //recalculate moved text group
        //recalculate all child textgroups ranges to account for move
        //recalculate all subsequent textgroups ranges to account for prepended string
        var movedTextGroupDelta: Int? = nil
        if let movedTextGroupOriginalRange = movedTextGroup?.token?.range {
            movedTextGroupDelta = locationToInsert - movedTextGroupOriginalRange.location
        }
        
        let newTextGroupRange = NSRange(location: locationToInsert + addition, length: movedTextGroup?.token?.range.length ?? 0)
        movedTextGroup?.token?.range = newTextGroupRange
        
        if let parentTextgroup = outlineModel?.parentTextGroup {
            
            for textGroup in parentTextgroup {
                
                guard let textGroupRange = textGroup.token?.range else {
                    continue
                }
                
                if textGroup.parentTextGroup == movedTextGroup {
                    
                    guard let movedTextGroupDelta = movedTextGroupDelta else {
                        print("Error recalculating child text group")
                        continue
                    }
                    let newTextGroupRange = NSRange(location: textGroupRange.location + movedTextGroupDelta, length: textGroupRange.length)
                    textGroup.token?.range  = newTextGroupRange
                }
                else if textGroupRange.location >= locationToInsert {
                    
                    let newTextGroupRange = NSRange(location: textGroupRange.location + attributedString.string.count, length: textGroupRange.length)
                    textGroup.token?.range = newTextGroupRange
                }
            }
        }
    }
    
    func removeTextGroup(_ textGroup: TextGroup, outlineModel: OutlineModel?, downwardDraggingGroup: TextGroup?, completion: ((Bool)->())?) {
        
        guard let textStorage = textStorage, let range = outlineModel?.range(of: textGroup, in: textStorage) else {
            completion?(false)
            return
        }
        
        remove(range: range, expandingTextGroup: nil, downwardDraggingGroup: downwardDraggingGroup, removingTextGroup: textGroup)
        completion?(true)
    }
    
    func remove(range: NSRange, expandingTextGroup: TextGroup?, downwardDraggingGroup: TextGroup?, removingTextGroup: TextGroup?) {
        
        textStorage.replaceCharacters(in: range, with: "")
        outlineModel?.reCalculateTextGroups(replacingRange: range, with: "", expandingTextGroup: expandingTextGroup, downwardDraggingGroup: downwardDraggingGroup, removingTextGroup: removingTextGroup)
    }
    
    func beginUpdates() {
        textStorage?.beginEditing()
    }
    
    func endUpdates() {
        textStorage?.endEditing()
    }
}
