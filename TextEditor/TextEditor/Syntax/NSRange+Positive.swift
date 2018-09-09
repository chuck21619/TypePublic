//
//  NSRange+Positive.swift
//  TextEditor
//
//  Created by charles johnston on 9/8/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension NSRange {
    
    var positive: NSRange {
        
        if self.length < 0 {
            
            let length = abs(self.length)
            let location = self.location - length
            let positiveRange = NSRange(location: location, length: length)
            return positiveRange
        }
        else {
            return self
        }
    }
}
