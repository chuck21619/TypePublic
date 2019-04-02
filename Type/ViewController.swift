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

class ViewController: NSViewController, PanelsDelegate, TextEditorViewControllerDelegate {

    @IBOutlet weak var panels: Panels!
    
    var sideboard: NSViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panels.delegate = self
        
        guard let mainPanelViewController = TextEditorViewController.createInstance(delegate: self, documentOpener: DocumentOpener()) else {
            return
        }
        
        let mainPanel = Panel(position: .main, viewController: mainPanelViewController, defaultWidth: 720)
        
        
//        let sideboardStoryboard = NSStoryboard(name: "Sideboard", bundle: Bundle.main)
//        sideboard = sideboardStoryboard.instantiateInitialController() as? SideboardViewController
//        let rightPanel = Panel(position: .right, viewController: sideboard, hidingThreshold: 150, defaultWidth: 312)
        
        
        
        
        
        
        let fileBrowserStoryboard = NSStoryboard(name: "FileBrowser", bundle: Bundle.main)
        let leftPanelViewController = fileBrowserStoryboard.instantiateInitialController() as? NSViewController
        let leftPanel = Panel(position: .left, viewController: leftPanelViewController)
        
        

        panels.set(panels: [leftPanel/*, rightPanel*/, mainPanel])
    }
    
    //MARK: - TextEditorViewControllerDelegate
    func presentSideboard(viewController: NSViewController) {
        
        let sideboardViewController = SideboardViewController.create(with: viewController)
        
        panels.set(panels: [Panel(position: .right, viewController: sideboardViewController)])
    }
    
    // MARK: - PanelsDelegate
    func didStartResizing(panelPosition: PanelPosition) {
        
        if panelPosition == .right {
            
            if let sideboard = sideboard as? SideboardViewController {
                sideboard.setScrollbarHidden(true)
            }
        }
    }
    
    func didEndResizing(panelPosition: PanelPosition, hidingPanel: Bool) {
        
        if panelPosition == .right {
            
            if let sideboard = sideboard as? SideboardViewController {
                sideboard.setScrollbarHidden(false)
            }
        }
    }
}

