//
//  RegularExpressionPatternFactory.swift
//  TextEditor
//
//  Created by charles johnston on 8/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class RegularExpressionPatternFactory {
    
    //            let regexStr = "^s*-.*"
    
    //            let regexStr = "\\b(\(keyword.stringValue))\\b"
    static func pattern(keyword: String) -> String {
        
        return "\\b(\(keyword))\\b"
    }
    
    static func pattern(beginning: String, ending: String) -> String {
        
        return "^\\s*\(beginning).*\(ending)"
    }
}
