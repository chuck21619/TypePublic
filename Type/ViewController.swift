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
    
    @IBAction func rightButtonPushed(_ sender: Any) {
        
        //right
        panels.toggleRightPanel()
    }
    
    @IBAction func leftButtonPushed(_ sender: Any) {
        
//        panels.togg
        panels.toggleLeftPanel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TestViewController"), bundle: Bundle.main)
        
        let leftPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController)
        
        let rightPanelViewController = storyboard.instantiateInitialController() as? NSViewController
        let rightPanel = Panel(position: .right, viewController: rightPanelViewController)
        
        
        guard let mainPanelViewController = TextEditorViewController.gimme() else {
            return
        }
        
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController, defaultWidth: 500)

        panels.set(panels: [leftPanel, rightPanel, mainPanel])
    }
}

