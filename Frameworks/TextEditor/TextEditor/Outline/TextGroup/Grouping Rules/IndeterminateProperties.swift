//
//  IndeterminateProperties.swift
//  TextEditor
//
//  Created by charles johnston on 10/30/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct IndeterminateProperties: Equatable {
    
    // used to determine order when grouping rule contains indeterminate regex matches
    // example:
    //   # h1 title
    //   ## h2 title
    //
    // if true, will put lower number as higher priority
    // so in the above example, h1 title would have a higher priority than h2 title
    //
    // if regex matches are determinate, then value has no effect
    let ascending: Bool
    
    // label of the regular expression group of the indeterminate pattern
    let indeterminateGroupLabel: String
}
