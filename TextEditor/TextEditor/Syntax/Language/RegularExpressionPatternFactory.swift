//
//  RegularExpressionPatternFactory.swift
//  TextEditor
//
//  Created by charles johnston on 8/20/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class RegularExpressionPatternFactory {
    
    static func pattern(keyword: String) -> String {
        
        let escapedKeyword = RegularExpressionPatternFactory.escapeSpecialCharacters(keyword)
        return "\\b(\(escapedKeyword))\\b"
    }
    
    static func pattern(beginning: String, ending: String) -> String {
        
        let escapedBeginning = RegularExpressionPatternFactory.escapeSpecialCharacters(beginning)
        let escapedEnding = RegularExpressionPatternFactory.escapeSpecialCharacters(beginning)
        return "\(escapedBeginning).*\(escapedEnding)"
    }
    
    static func pattern(lineBeginning: String) -> String {
        
        let escapedLineBeginning = RegularExpressionPatternFactory.escapeSpecialCharacters(lineBeginning)
        return "^\\s*\(escapedLineBeginning).*"
    }
    
    private static func escapeSpecialCharacters(_ string: String) -> String {
        
        var escapedString = string
        escapedString = escapedString.replacingOccurrences(of: "*", with: "\\*")
        escapedString = escapedString.replacingOccurrences(of: "+", with: "\\+")
        return escapedString
    }
}
