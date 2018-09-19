//
//  EditTypeRangeCalculator.swift
//  TextEditor
//
//  Created by charles johnston on 9/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol AttributeEditRangeCalculator {
    
    func calcRange(attributeOccurrence: AttributeOccurrence, editedRange: NSRange, changeInLength: Int) -> NSRange?
}
