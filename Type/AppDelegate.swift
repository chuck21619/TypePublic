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
        let mainMenu = applicationMenuFactory.createApplicationMenu()
        NSApplication.shared.mainMenu = mainMenu
    }

    // MARK: - menu actions
    @IBAction func menuViewFolio(_ sender: Any) {
        
        NotificationCenter.default.post(showLeftPanel)
    }
    
    @IBAction func menuViewSideboard(_ sender: Any) {
        
        NotificationCenter.default.post(showRightPanel)
    }
}

