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

    @IBAction func buttonClicked(_ sender: Any) {
        print("")
    }
    @IBOutlet weak var panels: Panels!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TestViewController"), bundle: Bundle.main)
        
        let storyboard2 = NSStoryboard(name: NSStoryboard.Name(rawValue: "TestViewControllerTwo"), bundle: Bundle.main)
        
        let leftPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController)

        let rightPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let rightPanel = Panel(position: .right, viewController: rightPanelViewController)
        
        let mainPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController)
        
        panels.set(panels: [leftPanel, rightPanel, mainPanel])
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

