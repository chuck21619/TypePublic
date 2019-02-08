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
        
        let fileBrowserStoryboard = NSStoryboard(name: "FileBrowser", bundle: Bundle.main)
        let sideboardStoryboard = NSStoryboard(name: "Sideboard", bundle: Bundle.main)
        
        let leftPanelViewController = fileBrowserStoryboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController, hidingThreshold: 100, defaultWidth: 200)
        
        let rightPanelViewController = sideboardStoryboard.instantiateInitialController() as? NSViewController
        let rightPanel = Panel(position: .right, viewController: rightPanelViewController, hidingThreshold: 100, defaultWidth: 300)
        
        
        guard let mainPanelViewController = TextEditorViewController.createInstance() else {
            return
        }
        
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController, defaultWidth: 500)

        panels.set(panels: [leftPanel, rightPanel, mainPanel])
    }
}

