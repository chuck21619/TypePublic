//
//  NSRange+Intersects.swift
//  TextEditor
//
//  Created by charles johnston on 9/18/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension NSRange {
    
    func intersects(_ otherRange: NSRange) -> Bool {
        
        if self.intersection(otherRange) != nil {
            
            return true
        }
        
        return false
    }
}
