//
//  ResizeMainPanelBehavior.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class ResizeMainPanelBehavior: ResizeBehavior {
    func toggleLeftPanel(_ panel: Panel) {
        //
    }
    
    func toggleRightPanel(_ panel: Panel) {
        //
    }
    
    
    func didStartWindowResize(_ sides: [Side]) {
        //
    }
    
    func didEndWindowResize(minimumSize: NSSize) {
        //
    }
    
    func didEndWindowResize() {
        //
    }
    
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        return  frameSize
    }
    
    func handleWindowResized(window: NSWindow) {
        //
    }
    
    var delegate: ResizeBehaviorDelegate
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        //
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        //
    }
}
