//
//  OutlineView.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineViewController: NSViewController, OutlineModelDelegate {
    
    // MARK: - Properties
    var model: OutlineModel? = nil
    
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
    
    // MARK: stuff
    private func updateOutline(textGroups: [TextGroup]?) {
        
        guard let textGroups = textGroups, textGroups.isEmpty == false else {
            
            clearOutline()
            return
        }
        
        print("update outline: \(textGroups)")
        
        DispatchQueue.main.async {
            self.testingTextView.string = textGroups.description
        }
        
    }
    
    private func clearOutline() {
        
        print("clear outline")
        
        DispatchQueue.main.async {
            self.testingTextView.string = ""
        }
    }
    
    // MARK: - OutlineModelDelegate
    func didUpdate(textGroups: [TextGroup]?) {
        
        updateOutline(textGroups: textGroups)
    }
}
