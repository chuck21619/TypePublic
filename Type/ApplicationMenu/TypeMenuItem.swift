//
//  TypeMenuItem.swift
//  Type
//
//  Created by charles johnston on 3/18/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class TypeMenuItem: NSMenuItem {
    
    //holds a notification to be posted when called
    let notification: Notification
    
    init(title string: String, action selector: Selector?, keyEquivalent charCode: String, keyEquivalentModifierMask: NSEvent.ModifierFlags = [], notification: Notification) {
        
        self.notification = notification
        super.init(title: string, action: selector, keyEquivalent: charCode)
        self.keyEquivalentModifierMask = keyEquivalentModifierMask
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
