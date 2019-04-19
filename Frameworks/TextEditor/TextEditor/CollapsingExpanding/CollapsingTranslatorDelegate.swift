//
//  CollapsingTranslatorDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 1/21/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

protocol CollapsingTranslatorDelegate: class {
    
    func invalidateRanges(invalidRanges: [NSRange])
}
