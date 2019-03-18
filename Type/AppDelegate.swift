//
//  AppDelegate.swift
//  Type
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Cocoa
import Panels

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - PROPERTIES
    // MARK: - METHODS
    // MARK: - launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //set the application menu
        let applicationMenuFactory = ApplicationMenuFactory()
        let mainMenu = applicationMenuFactory.createApplicationMenu(menuItemNotificationPoster: #selector(postMenuItemNotification))
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func postMenuItemNotification(sender: Any) {
        
        guard let menuItem = sender as? TypeMenuItem else {
            return
        }
        
        let notification = menuItem.notification
        
        NotificationCenter.default.post(notification)
    }
}

