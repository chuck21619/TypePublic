//
//  TextEditorTypeSetter.swift
//  TextEditor
//
//  Created by charles johnston on 11/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorTypeSetter: NSATSTypesetter {
    
    override func layoutCharacters(in characterRange: NSRange, for layoutManager: NSLayoutManager, maximumNumberOfLineFragments maxNumLines: Int) -> NSRange {
        
        let result = super.layoutCharacters(in: characterRange, for: layoutManager, maximumNumberOfLineFragments: maxNumLines)
        
//        super.layoutCharacters(in: <#T##NSRange#>, for: <#T##NSLayoutManager#>, maximumNumberOfLineFragments: <#T##Int#>)
        return result
    }
}
