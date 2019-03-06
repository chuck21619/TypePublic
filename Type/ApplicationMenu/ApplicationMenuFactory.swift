//
//  ApplicationMenuFactory.swift
//  Type
//
//  Created by charles johnston on 3/6/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class ApplicationMenuFactory {
    
    func createApplicationMenu() -> NSMenu {
        
        let mainMenu = NSMenu(title: "Type")
        
        let fileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        let fileMenu = NSMenu(title: "File")
        mainMenu.addItem(fileMenuItem)
        mainMenu.setSubmenu(fileMenu, for: fileMenuItem)
        
        let viewMenuItem = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
        let viewMenu = NSMenu(title: "View ") // "View" (without space) will cause a default enter fullscreen menu item (bug: https://github.com/nwjs/nw.js/issues/6332)
        let viewFullscreenMenuItem = NSMenuItem(title: "Fullscreen", action: nil, keyEquivalent: "")
        viewMenu.addItem(viewFullscreenMenuItem)
        let viewToggleFolioMenuItem = NSMenuItem(title: "Toggle Folio", action: nil, keyEquivalent: "")
        viewMenu.addItem(viewToggleFolioMenuItem)
        let viewToggleSideboardMenuItem = NSMenuItem(title: "Toggle Sideboard", action: nil, keyEquivalent: "")
        viewMenu.addItem(viewToggleSideboardMenuItem)
        mainMenu.addItem(viewMenuItem)
        mainMenu.setSubmenu(viewMenu, for: viewMenuItem)
        
        let helpMenuItem = NSMenuItem(title: "Help", action: nil, keyEquivalent: "")
        let helpMenu = NSMenu(title: "Help")
        mainMenu.addItem(helpMenuItem)
        mainMenu.setSubmenu(helpMenu, for: helpMenuItem)
        
        return mainMenu
    }
    
}
