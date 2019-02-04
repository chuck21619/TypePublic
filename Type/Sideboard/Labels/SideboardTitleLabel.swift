//
//  SideboardTitleLabel.swift
//  Type
//
//  Created by charles johnston on 2/4/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class SideboardTitleLabel: NSTextField {
    
    override func awakeFromNib() {
        
        self.textColor = NSColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        self.font = NSFont.systemFont(ofSize: 14.0)
    }
}
