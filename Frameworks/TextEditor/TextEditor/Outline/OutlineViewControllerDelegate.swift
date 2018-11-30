//
//  OutlineViewControllerDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 11/8/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol OutlineViewControllerDelegate {
    
    func title(for textGroup: TextGroup) -> NSAttributedString?
    
    func removeTextGroup(_ textGroup: TextGroup)
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int)
    
    func beginUpdates()
    func endUpdates()
}
