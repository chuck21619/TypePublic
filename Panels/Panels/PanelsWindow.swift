//
//  PanelsWindow.swift
//  Type
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class PanelsWindow: NSWindow {
    
    var ignoreStandardResize = false
    
    override func setFrame(_ frameRect: NSRect, display flag: Bool) {
        
        guard ignoreStandardResize == false else {
            return
        }
        
        super.setFrame(frameRect, display: flag)
    }
    
    func setFrameOverride(_ frameRect: NSRect, display flag: Bool) {
        
        super.setFrame(frameRect, display: flag)
    }
}
