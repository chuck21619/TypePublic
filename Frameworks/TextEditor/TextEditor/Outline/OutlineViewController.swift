//
//  OutlineView.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineViewController: NSViewController, OutlineModelDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    // MARK: - Properties
    var model: OutlineModel? = nil
    var delegate: OutlineViewControllerDelegate? = nil
    private var parentTextGroup = TextGroup(title: "parent")
    private let columnReuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "columnReuseIdentifier")
    public var relaxReorderRules = false
    var collapsingTranslator: CollapsingTranslator? = nil
    
    // MARK: drag to reorder
    private var draggedFromIndex: Int = -1
    private var draggingGroup: TextGroup? = nil
    var visibleRect: NSRect? // save scroll position after reloading outline
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var allowInteraction: Bool {
        
        return !(model?.processing ?? true)
    }
    
    // MARK: - Methods
    // MARK: - Constructors
    public static func createInstance(delegate: OutlineViewControllerDelegate, collapsingTranslator: CollapsingTranslator?) -> OutlineViewController? {
        
        let bundle = Bundle(for: OutlineViewController.self)
        let storyboardName = String(describing: OutlineViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? OutlineViewController
        viewController?.delegate = delegate
        viewController?.collapsingTranslator = collapsingTranslator
        
        return viewController
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        
    }
    
    // MARK: Initialization
    override func viewDidLoad() {
        
        self.outlineView.dataSource = self
        self.outlineView.delegate = self
        
        self.outlineView.registerForDraggedTypes([TextGroup.pasteboardType])
    }
    
    // MARK: stuff
    var lastIntrinsicContentSize: NSSize = .zero
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    private func updateOutline(parentTextGroup: TextGroup?) {
        
        self.parentTextGroup = parentTextGroup ?? self.parentTextGroup
        
        DispatchQueue.main.async {
            
            self.outlineView.reloadData()
            self.outlineView.expandItem(nil, expandChildren: true)
            
            if let visibleRect = self.visibleRect {
                
                self.outlineView.scrollToVisible(visibleRect)
            }
            
            if self.outlineView.intrinsicContentSize != self.lastIntrinsicContentSize {
                
                print("resizing outline view")
                
                self.lastIntrinsicContentSize = self.outlineView.intrinsicContentSize
                
                self.scrollViewHeightConstraint.constant = self.lastIntrinsicContentSize.height + 3
            }
        }
    }
    
    // MARK: - OutlineModelDelegate
    func didUpdate(parentTextGroup: TextGroup?) {
        
        updateOutline(parentTextGroup: parentTextGroup)
    }
    
    func documentString() -> NSMutableAttributedString? {
    
        return self.delegate?.documentString()
    }
    
    // MARK: - NSOutlineViewDataSource
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        // a nil item represents the root node
        guard let textGroup = (item ?? parentTextGroup) as? TextGroup,
              textGroup.textGroups.indices.contains(index) else {
                
                return TextGroup(title: "Error")
        }
        
        return textGroup.textGroups[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let textGroup = item as? TextGroup else {
            return false
        }
        
        return !textGroup.textGroups.isEmpty
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            // root item
            return parentTextGroup.textGroups.count
        }
        
        guard let textGroup = item as? TextGroup else {
            return 0
        }
        
        return textGroup.textGroups.count
    }
    
    // MARK: drag to reorder
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {

        guard var textGroup = item as? TextGroup else {
            return nil
        }
        
        for iteratedTextgroup in model!.parentTextGroup {
            
            //TODO: fix this. comparing titles is not a valid solution
            if textGroup.title == iteratedTextgroup.title {
                
                textGroup = iteratedTextgroup
                break
            }
        }
        
        draggedFromIndex = outlineView.childIndex(forItem: item)
        draggingGroup = textGroup
        
        return textGroup
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        guard let draggingGroup = draggingGroup else {
            return []
        }
        // if item is nil, then target is root
        let targetParent = item as? TextGroup ?? parentTextGroup
        
        // do not allow drops directly onto groups
        guard index != NSOutlineViewDropOnItemIndex else {
            return []
        }
        
        // do not allow dropping into itself
        guard targetParent.isDescendant(of: draggingGroup) == false else {
            return []
        }
        
        // no operation should occur when dropping to same location
        if targetParent == draggingGroup.parentTextGroup {
            guard index != draggedFromIndex, index != draggedFromIndex+1 else {
                return []
            }
        }
        
        //TODO: Add option in settings?
        if relaxReorderRules == false,
           let language = model?.language,
           let targetParentToken = targetParent.token,
           let draggingGroupToken = draggingGroup.token {
            
            let targetParentHasHigherPriority = language.priority(of: targetParentToken, isHigherThan: draggingGroupToken)
            
            guard targetParentHasHigherPriority else {
                
                return []
            }
        }
        
        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        
        guard let collapsingTranslator = collapsingTranslator,
              let delegate = self.delegate,
              let string = delegate.documentString(),
              let model = self.model else {
            return false
        }
        
        delegate.beginUpdates()
        
        collapsingTranslator.expandAllTextGroups(string: string, collapsedTextGroups: delegate.collapsedTextGroups, outlineModel: model)
        
        // if item is nil, then target is root
        var targetParent = item as? TextGroup ?? parentTextGroup
        
        for iteratedTextGroup in model.parentTextGroup {
            
            //TODO: fix this. comparing titles is not a valid solution
            if targetParent.title == iteratedTextGroup.title {
                
                targetParent = iteratedTextGroup
                break
            }
        }
        
        for iteratedTextGroup in model.parentTextGroup {
            
            //TODO: fix this. comparing titles is not a valid solution
            if draggingGroup?.title == iteratedTextGroup.title {
                
                draggingGroup = iteratedTextGroup
                break
            }
        }
        
        guard let draggingGroup = draggingGroup else {
            return false
        }
        
        var insertIndex = index
        if targetParent == draggingGroup.parentTextGroup, index > draggedFromIndex {
            
            insertIndex -= 1
        }
        
        //fix: the draggingGroup.parentTextGroup is nil after collapsing an unrelated textgroup
        guard let textGroupString = delegate.string(for: draggingGroup, outlineModel: self.model) else {
            return false
        }
        
        visibleRect = outlineView.visibleRect
        
        delegate.removeTextGroup(draggingGroup, outlineModel: self.model)
        delegate.insertAttributedString(textGroupString, in: targetParent, at: insertIndex, outlineModel: self.model, movedTextGroup: draggingGroup)
        
        collapsingTranslator.recollapseTextGroups(string: string, outlineModel: model, invalidRanges: [], collapsedTextGroups: delegate.collapsedTextGroups)
        
        delegate.endUpdates()
        
        return true
    }
    
    // MARK: - NSOutlineViewDelegate
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        guard let textGroup = item as? TextGroup, let view = outlineView.makeView(withIdentifier: columnReuseIdentifier, owner: self) as? NSTableCellView else {
            
            return nil
        }
        
        view.textField?.stringValue = textGroup.title
        
        return view
    }
    
    //Returns whether the specified item should display the outline cell (the disclosure triangle).
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {

        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        
        return []
    }
}
