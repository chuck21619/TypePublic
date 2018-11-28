//
//  TextEditorLayoutManager.swift
//  TextEditor
//
//  Created by charles johnston on 8/31/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextEditorLayoutManager: NSLayoutManager {
    
    override init() {
        super.init()
        self.typesetter = TextEditorTypeSetter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
