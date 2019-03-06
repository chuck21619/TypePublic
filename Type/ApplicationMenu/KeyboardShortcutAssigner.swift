//
//  KeyboardShortcuts.swift
//  Type
//
//  Created by charles johnston on 3/6/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class KeyboardShortcutAssigner {
    
    
    
    // MARK: - initialization
    init() {

        // test
//        let menuItem = NSApplication.shared.mainMenu!.items[4].submenu!.items[0]
//
//        menuItem.action = #selector(testMethod)
//        menuItem.target = self
//        menuItem.isEnabled = true
    }

    // test
//    @objc func testMethod() {
//
//        print("test method")
//    }
    
    // setup initial key mapping from saved profile
    
    // get menu item
    
    // MARK: - etc.
    func assignKeyboardShortcut(menuItem: NSMenuItem, keyEquivalent: String, keyEquivalentModifierMask: NSEvent.ModifierFlags) {
        
        menuItem.keyEquivalent = keyEquivalent
        menuItem.keyEquivalentModifierMask = keyEquivalentModifierMask
        
        
        
        //test
//        let menuItem = NSApplication.shared.mainMenu!.items[4].submenu!.items[0]
//
//        let arrowKey = NSLeftArrowFunctionKey
//
//
//        let keyEqualicant = Character("1")
//
//        menuItem.keyEquivalent = String(keyEqualicant)
//        menuItem.keyEquivalentModifierMask = [.command]
//
//        print("")
    }
}
