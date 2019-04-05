//
//  OutlineViewControllerDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 11/8/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol OutlineViewControllerDelegate {
    
    func documentString() -> NSMutableAttributedString?
    
    func string(for textGroup: TextGroup, outlineModel: OutlineModel?) -> NSAttributedString?
    
    func removeTextGroup(_ textGroup: TextGroup, outlineModel: OutlineModel?, downwardDraggingGroup: TextGroup?, completion: ((Bool)->())?)
    func remove(range: NSRange, expandingTextGroup: TextGroup?, downwardDraggingGroup: TextGroup?)
    func insertAttributedString(_ attributedString: NSAttributedString, in textGroup: TextGroup, at index: Int, outlineModel: OutlineModel?, movedTextGroup: TextGroup?)
    
    func beginUpdates()
    func endUpdates()
}
