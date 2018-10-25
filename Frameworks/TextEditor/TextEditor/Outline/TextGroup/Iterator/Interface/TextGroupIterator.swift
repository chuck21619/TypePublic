//
//  TextGroupIterator.swift
//  TextEditor
//
//  Created by charles johnston on 10/24/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextGroupIterator {
    
    func next() -> TextGroup?
    func hasNext() -> Bool
}
