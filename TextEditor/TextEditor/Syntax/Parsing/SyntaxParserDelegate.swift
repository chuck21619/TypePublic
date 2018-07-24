//
//  SyntaxParserDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol SyntaxParserDelgate {
    
    func didParseSyntax(string: NSAttributedString)
}
