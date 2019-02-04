//
//  ViewController.swift
//  Type
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Cocoa
import Panels
import TextEditor

class ViewController: NSViewController {

    @IBOutlet weak var panels: Panels!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = NSStoryboard(name: "TestViewController", bundle: Bundle.main)
        
        let sideboardStoryboard = NSStoryboard(name: "Sideboard", bundle: Bundle.main)
        
        let leftPanelViewController = sideboardStoryboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController, hidingThreshold: 200, defaultWidth: 300)
        
        let rightPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let rightPanel = Panel(position: .right, viewController: rightPanelViewController)
        
        
        guard let mainPanelViewController = TextEditorViewController.createInstance() else {
            return
        }
        
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController, defaultWidth: 500)

        panels.set(panels: [leftPanel, rightPanel, mainPanel])
    }
}

