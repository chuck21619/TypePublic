//
//  NSAttributeProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol NSAttributeProvider {
    
    func attributes(for keyword: Keyword, in string: String, changedRange: NSRange) -> [AttributeApplication]
}
