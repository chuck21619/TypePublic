//
//  SyntaxHighlighterDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 9/26/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol SyntaxHighlighterDelegate {
    
    func invalidateRanges(invalidRanges: [NSRange])
    func willAddAttributes(_ SyntaxHighlighter: SyntaxHighligher)
    func didAddAttributes(_ SyntaxHighlighter: SyntaxHighligher)
}
