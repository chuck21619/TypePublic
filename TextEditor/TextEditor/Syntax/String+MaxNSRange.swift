//
//  String+MaxNSRange.swift
//  TextEditor
//
//  Created by charles johnston on 9/9/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension String {
    
    var maxNSRange: NSRange {
        
        return NSRange(self.startIndex.encodedOffset ..< self.endIndex.encodedOffset)
    }
    
    
}
