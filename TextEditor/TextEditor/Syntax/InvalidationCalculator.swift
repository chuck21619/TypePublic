//
//  InvalidationCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 8/31/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class InvalidationCalculator {
    
    // TODO: figure out when to invalidate region (currently the markdown block quotes and markdown = signaling a h1 title require additional invalidation)
    // TODO: figure out the size of the rect to invalidate
    func rectangle() -> NSRect {
        
        return NSRect(x: 0, y: 0, width: 100, height: 100)
    }
}
