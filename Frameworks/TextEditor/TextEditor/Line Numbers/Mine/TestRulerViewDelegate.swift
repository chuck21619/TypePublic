//
//  TestRulerViewDelegate.swift
//  TextEditor
//
//  Created by charles johnston on 11/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TestRulerViewDelegate: class {
    
    func markerClicked(_ marker: TextGroupMarker, completion: @escaping ()->())
}
