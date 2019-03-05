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


    @IBAction func menuViewFolio(_ sender: Any) {
        
        NotificationCenter.default.post(showLeftPanel)
    }
    
    @IBAction func menuViewSideboard(_ sender: Any) {
        
        NotificationCenter.default.post(showRightPanel)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

