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

class ViewController: NSViewController, PanelsDelegate {

    @IBOutlet weak var panels: Panels!
    
    var sideboard: SideboardViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panels.delegate = self
        
        let fileBrowserStoryboard = NSStoryboard(name: "FileBrowser", bundle: Bundle.main)
        let sideboardStoryboard = NSStoryboard(name: "Sideboard", bundle: Bundle.main)
        
        let leftPanelViewController = fileBrowserStoryboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController, hidingThreshold: 100, defaultWidth: 200)
        
        sideboard = sideboardStoryboard.instantiateInitialController() as? SideboardViewController
        let rightPanel = Panel(position: .right, viewController: sideboard, hidingThreshold: 150, defaultWidth: 312)
        
        
        guard let mainPanelViewController = TextEditorViewController.createInstance() else {
            return
        }
        
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController, defaultWidth: 700)

        panels.set(panels: [leftPanel, rightPanel, mainPanel])
    }
    
    // MARK: - PanelsDelegate
    func didStartResizing(panelPosition: PanelPosition) {
        
        if panelPosition == .right {
            
            sideboard?.setScrollbarHidden(true)
        }
    }
    
    func didEndResizing(panelPosition: PanelPosition, hidingPanel: Bool) {
        
        if panelPosition == .right {
            
            sideboard?.setScrollbarHidden(hidingPanel)
        }
    }
}

