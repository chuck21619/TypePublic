//
//  SideboardDefaultLabel.swift
//  Type
//
//  Created by charles johnston on 2/4/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class OuterPanelDefaultLabel: NSTextField {
    
    override func awakeFromNib() {
        
        self.textColor = NSColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        self.font = NSFont.systemFont(ofSize: 12.0)
    }
}
