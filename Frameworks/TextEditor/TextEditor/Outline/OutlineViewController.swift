//
//  OutlineView.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class OutlineViewController: NSViewController {
    
    var model: OutlineModel? = nil
    
    var allowInteraction: Bool {
        
        return !(model?.processing ?? true)
    }
}
