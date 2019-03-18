//
//  ApplicationMenuFactory.swift
//  Type
//
//  Created by charles johnston on 3/6/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit
import Panels

class ApplicationMenuFactory {
    
    func createApplicationMenu(menuItemNotificationPoster: Selector?) -> NSMenu {
        
        let mainMenu = NSMenu(title: "Type")
        
        let fileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        let fileMenu = NSMenu(title: "File")
        mainMenu.addItem(fileMenuItem)
        mainMenu.setSubmenu(fileMenu, for: fileMenuItem)
        
        let viewMenuItem = NSMenuItem(title: "View", action: nil, keyEquivalent: "")
        let viewMenu = NSMenu(title: "View ") // "View" (without space) will cause a default enter fullscreen menu item (bug: https://github.com/nwjs/nw.js/issues/6332)
        let viewFullscreenMenuItem = NSMenuItem(title: "Fullscreen", action: nil, keyEquivalent: "")
        viewMenu.addItem(viewFullscreenMenuItem)
        let viewToggleFolioMenuItem = TypeMenuItem(title: "Toggle Folio", action: menuItemNotificationPoster, keyEquivalent: "1", keyEquivalentModifierMask: [.command], notification: showLeftPanel)
        viewMenu.addItem(viewToggleFolioMenuItem)
        let viewToggleSideboardMenuItem = TypeMenuItem(title: "Toggle Sideboard", action: menuItemNotificationPoster, keyEquivalent: "2", keyEquivalentModifierMask: [.command], notification: showRightPanel)
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
