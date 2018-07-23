//
//  TextEditorViewController.swift
//  TextEditor
//
//  Created by charles johnston on 7/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

public class TextEditorViewController: NSViewController {
    
    @IBOutlet var textEditorView: TextEditorView!
    // MARK: - Constructors
//    public init() {
//        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: String(describing: TextEditorViewController.self)), bundle: Bundle.main)
//
//        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
//        self.commonInit()
//    }
    
    public static func gimme() -> TextEditorViewController? {
        
        let bundle = Bundle(for: TextEditorViewController.self)
        let storyboardName = NSStoryboard.Name(rawValue: String(describing: TextEditorViewController.self))
        let storyboard = NSStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateInitialController() as? TextEditorViewController
        
        viewController!.commonInit()
        
        return viewController
    }

//    required public init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.commonInit()
//    }
//    
    func commonInit() {
        
        print("common init")
//        let view = TextEditorView()
//        self.view.addSubview(view)
//        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
