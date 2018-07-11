//
//  ResizeBehavior.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

enum Side {
    case left
    case right
    case top
    case bottom
}

protocol ResizeBehavior {
    
    // resizing from resize bars
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel)
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel)
    
    // resizing from window edges
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize
    func didStartWindowResize(_ sides: [Side])
    func didEndWindowResize(minimumSize: NSSize)
    
    //
    var delegate: ResizeBehaviorDelegate { get }
    
    init(delegate: ResizeBehaviorDelegate)
}
