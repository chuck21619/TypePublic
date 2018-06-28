//
//  ViewController.swift
//  Type
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Cocoa
import Panels

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let leftPanel = NSViewController()
        
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TestViewController"), bundle: Bundle.main)
        let leftPanel = storyboard.instantiateInitialController() as? NSViewController
        
//        let mainPanel = NSViewController()
//        let rightPanel = NSViewController()
        
        
        guard let panels = Panels.sweetHomeAlabama(leftPanel: leftPanel, mainPanel: nil, rightPanel: nil) else {
            return
        }
        
        
        self.view.addSubview(panels)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

