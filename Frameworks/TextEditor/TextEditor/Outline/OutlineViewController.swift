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
    
    // MARK: drag to reorder
    private var draggedFromIndex: Int = -1
    private var draggingGroup: TextGroup? = nil
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var allowInteraction: Bool {
        
        return !(model?.processing ?? true)
    }
    
    // MARK: - Methods
    // MARK: - Constructors
    public static func createInstance(delegate: OutlineViewControllerDelegate) -> OutlineViewController? {
        
        let bundle = Bundle(for: OutlineViewController.self)
        let storyboardName = String(describing: OutlineViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? OutlineViewController
        viewController?.delegate = delegate
        
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
    private func updateOutline(textGroups: [TextGroup]?) {
        
        parentTextGroup.textGroups = textGroups ?? []
        
        DispatchQueue.main.async {
            
            self.outlineView.reloadData()
            self.outlineView.expandItem(nil, expandChildren: true)
        }
    }
    
    // MARK: - OutlineModelDelegate
    func didUpdate(textGroups: [TextGroup]?) {
        
        updateOutline(textGroups: textGroups)
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

        guard let textGroup = item as? TextGroup else {
            return nil
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
        guard draggingGroup.isDescendant(of: targetParent) == false else {
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
        
        // if item is nil, then target is root
        let targetParent = item as? TextGroup ?? parentTextGroup
        
        guard let draggingGroup = draggingGroup else {
            return false
        }
        
        var insertIndex = index
        if targetParent == draggingGroup.parentTextGroup, index > draggedFromIndex {
            
            insertIndex -= 1
        }
        
        let adjacentTextGroup: TextGroup
        if index == 0 {
            
            adjacentTextGroup = targetParent.textGroups[index]
        }
        else {
            
            adjacentTextGroup = targetParent.textGroups[index-1]
        }
        
        guard let textGroupString = delegate?.attributedString(for: draggingGroup) else {
            return false
        }
        
        delegate?.beginUpdates()
        if draggingGroup.token!.range.location < adjacentTextGroup.token!.range.location {
            
            delegate?.insertAttributedString(textGroupString, in: targetParent, at: index)
            delegate?.removeTextGroup(draggingGroup)
        }
        else {
            
            delegate?.removeTextGroup(draggingGroup)
            delegate?.insertAttributedString(textGroupString, in: targetParent, at: insertIndex)
        }
        delegate?.endUpdates()
        
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
