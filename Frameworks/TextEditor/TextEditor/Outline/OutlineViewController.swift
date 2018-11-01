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
    var parentTextGroup = TextGroup(title: "parent")
    let columnReuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "columnReuseIdentifier")
    
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
    }
    
    // MARK: stuff
    private func updateOutline(textGroups: [TextGroup]?) {
        
        parentTextGroup.textGroups = textGroups ?? []
        
        DispatchQueue.main.async {
            
            self.outlineView.reloadData()
        }
        
//        guard let textGroups = textGroups, textGroups.isEmpty == false else {
//
//            clearOutline()
//            return
//        }
//
//        print("update outline: \(textGroups)")
//
//        DispatchQueue.main.async {
//            self.testingTextView.string = textGroups.description
//        }
    }
    
//    private func clearOutline() {
//
//        print("clear outline")
//
//        DispatchQueue.main.async {
//            self.testingTextView.string = ""
//        }
//    }
    
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
    
    // MARK: - NSOutlineViewDelegate
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        guard let textGroup = item as? TextGroup, let view = outlineView.makeView(withIdentifier: columnReuseIdentifier, owner: self) as? NSTableCellView else {
            
            return nil
        }
        
        view.textField?.stringValue = textGroup.title
        
        return view
    }
}
