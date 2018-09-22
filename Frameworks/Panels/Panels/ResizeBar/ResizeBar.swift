//
//  ResizeBar.swift
//  Panels
//
//  Created by charles johnston on 7/2/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class ResizeBar: NSView {
    
    override func resetCursorRects() {
        addCursorRect(self.bounds, cursor: .resizeLeftRight)
    }
}
