//
//  WindowController.swift
//  Type
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation
import AppKit
import Panels

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        
        if let panels = (contentViewController as? ViewController)?.panels {
            
            self.window?.delegate = panels
            
            let frame = NSRect(origin: self.window?.frame.origin ?? .zero, size: panels.defaultSize())
            self.window?.setFrame(frame, display: true)
        }
    }
    
//     MARK: Constructors
//    override init(window: NSWindow?) {
//        super.init(window: window)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//    
//    private func commonInit() {
//
//        print("a")
//    }
}
