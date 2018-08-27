//
//  Attribute.swift
//  TextEditor
//
//  Created by charles johnston on 8/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

struct Attribute {
    
    let key: NSAttributedStringKey
    let value: Any
    
    func NSAttribute() -> [NSAttributedStringKey : Any] {
        
        return [key : value]
    }
}
