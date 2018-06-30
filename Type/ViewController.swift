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

    @IBOutlet weak var mycustomview: NSView!
    @IBAction func buttonClicked(_ sender: Any) {
        print("")
    }
    @IBOutlet weak var panels: Panels!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mycustomview.wantsLayer = true
        mycustomview.layer?.borderWidth = 1
        
//        panels.wantsLayer = true
//        panels.layer?.borderWidth = 3
        
//        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TestViewController"), bundle: Bundle.main)
//        let leftPanel = storyboard.instantiateInitialController() as? NSViewController
//        
//        panels.setLeftPanel(leftPanel)
        
//        let rightPanel = storyboard.instantiateInitialController() as? NSViewController
//        
//        panels.setRightPanel(rightPanel)
//        
//        let mainPanel = storyboard.instantiateInitialController() as? NSViewController
//        
//        panels.setMainPanel(mainPanel)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

