//
//  SyntaxParserTests.swift
//  TextEditorTests
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import XCTest
@testable import TextEditor

class SyntaxParserTests: XCTestCase, SyntaxParserDelgate {

    func testParseMarkdownWithBlueKeyword() {
        
        let string = "my face is blue and your face is red"
        let syntaxParser = SyntaxParser(delegate: self)
        syntaxParser.parseText(string)
        
        //verify 'blue' is blue
    }
    
    // MARK: - Syntax Parser Delegate
    var parsedString: NSAttributedString?
    func didParseSyntax(string: NSAttributedString) {
        self.parsedString = string
    }
}
