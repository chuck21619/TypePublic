//
//  String+ContainsRange.swift
//  TextEditor
//
//  Created by charles johnston on 9/9/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension String {
    
    func contains(range: NSRange) -> Bool {
        
        let minimum = min(range.location, range.location + range.length)
        let maximum = max(range.location, range.location + range.length)
        
        if minimum < self.maxNSRange.location {
            return false
        }
        if maximum > self.maxNSRange.location + self.maxNSRange.length {
            return false
        }
        
        return true
    }
}
