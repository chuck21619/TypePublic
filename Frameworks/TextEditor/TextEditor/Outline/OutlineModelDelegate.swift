//
//  OutlineModelDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 10/31/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol OutlineModelDelegate: class {
    
    func testUpdate(parent: TextGroup?)
    func didUpdate(parentTextGroup: TextGroup?)
    func documentString() -> NSMutableAttributedString?
}
