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
    private var parentTextGroup = TextGroup(title: "parent")
    private let columnReuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "columnReuseIdentifier")
    
    // MARK: drag to reorder
    private var draggedFromIndex: Int = -1
    private var draggingGroup: TextGroup? = nil
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    // just for testing
    @IBOutlet var testingTextView: NSTextView!
    
    var allowInteraction: Bool {
        
        return !(model?.processing ?? true)
    }
    
    // MARK: - Methods
    // MARK: - Constructors
    public static func createInstance() -> OutlineViewController? {
        
        let bundle = Bundle(for: OutlineViewController.self)
        let storyboardName = String(describing: OutlineViewController.self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? OutlineViewController
        
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
        
        self.outlineView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "type.textGroup")])
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
        
        // TODO: clean up
        if item == nil {
            // root item
            guard parentTextGroup.textGroups.indices.contains(index) else {
                
                return TextGroup(title: "Error")
            }
            
            return parentTextGroup.textGroups[index]
        }
        else {
            
            guard let textGroup = item as? TextGroup, textGroup.textGroups.indices.contains(index) else {
                
                return TextGroup(title: "Error")
            }
            
            return textGroup.textGroups[index]
        }
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
        
        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        
//        let draggingPasteboard = info.draggingPasteboard
//
//        // idk why this line doesnt work
//        // let objects = draggingPasteboard.readObjects(forClasses: [TextGroup.self], options: nil)
//
//        guard let pasteboardItem = draggingPasteboard.pasteboardItems?.first,
//              let data = pasteboardItem.data(forType: NSPasteboard.PasteboardType(rawValue: "type.textGroup")),
//              let textGroup = NSKeyedUnarchiver.unarchiveObject(with: data) as? TextGroup else {
//            return false
//        }
        
        print("draggedFrom: \(draggedFromIndex)")
        print("draggedTo  : \(index)")
        
        draggingGroup?.parentTextGroup?.textGroups.remove(at: draggedFromIndex)
        updateOutline(textGroups: parentTextGroup.textGroups)
        
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
}
