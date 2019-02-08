//
//  OuterPanel.swift
//  Type
//
//  Created by charles johnston on 2/8/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class OuterPanelView: NSView {
    
    override func awakeFromNib() {
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0).cgColor
    }
}
