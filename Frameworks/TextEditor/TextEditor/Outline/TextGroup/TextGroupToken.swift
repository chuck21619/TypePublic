//
//  TextGroupToken.swift
//  TextEditor
//
//  Created by charles johnston on 10/19/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct TextGroupToken: Equatable {
    
    let label: String
    let range: NSRange
    let groupingRule: TextGroupingRule
}
