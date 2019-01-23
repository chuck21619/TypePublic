//
//  Settings.swift
//  TextEditor
//
//  Created by charles johnston on 1/23/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

struct Settings {
    
    let standardFont: NSFont
    
    init() {
        
        let standardFontSize: CGFloat = 11
        self.standardFont = NSFont(name: "Menlo", size: standardFontSize) ?? NSFont.systemFont(ofSize: standardFontSize)
    }
}
