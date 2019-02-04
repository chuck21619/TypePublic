//
//  SideboardSectionSeparator.swift
//  Type
//
//  Created by charles johnston on 2/4/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class SideboardSectionSeparator: NSView {
    
    override func awakeFromNib() {
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
    }
}
