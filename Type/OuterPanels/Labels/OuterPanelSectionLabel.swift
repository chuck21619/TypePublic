//
//  SideboardSectionLabel.swift
//  Type
//
//  Created by charles johnston on 2/4/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class OuterPanelSectionLabel: NSTextField {
    
    override func awakeFromNib() {
        
        self.textColor = NSColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        self.font = NSFont.systemFont(ofSize: 12.0)
    }
}
