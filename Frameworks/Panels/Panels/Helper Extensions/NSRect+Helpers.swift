//
//  NSRect+Helpers.swift
//  Panels
//
//  Created by charles johnston on 7/19/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

extension NSRect {
    
    func addedWidth(_ width: CGFloat) -> NSRect {
        
        return NSRect(x: self.minX,
                      y: self.minY,
                      width: self.width + width,
                      height: self.height)
    }
    
    func subtractedWidth(_ width: CGFloat) -> NSRect {
        
        return NSRect(x: self.minX,
                      y: self.minY,
                      width: self.width - width,
                      height: self.height)
    }
}
