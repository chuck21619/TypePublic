//
//  WindowController.swift
//  Type
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class WindowController: NSWindowController, NSWindowDelegate {

//    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
//        print(frameSize)
//        return frameSize
//    }
    
    func windowWillStartLiveResize(_ notification: Notification) {
        print("start resizing: \(notification)")
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        print("end resizing: \(notification)")
    }
}
