//
//  ResizeBehavior.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol ResizeBehavior {
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel)
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel)
    
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize
    
    var delegate: ResizeBehaviorDelegate { get }
    
    init(delegate: ResizeBehaviorDelegate)
}
