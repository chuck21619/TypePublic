//
//  ResizeWindowBehavior.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class ResizeWindowBehavior: ResizeBehavior {

    var delegate: ResizeBehaviorDelegate
    
    private var initialLeftPanelViewWidth: CGFloat = 0
    private var initialRightPanelViewWidth: CGFloat = 0
    private var initialResizingFrame: NSRect = .zero
    private var initialMouseLocation: NSPoint = .zero
    private var animatingSnap = false
    
    var magneticWhileResizing: Bool = true
    var magneticWhileResizingThreshold: CGFloat = 30
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
//    func animate(to width: CGFloat, from gesture: NSPanGestureRecognizer) {
//
//        guard animatingSnap == false else {
//
//            return
//        }
//
//        animatingSnap = true
//
//        var leftWidth = self.delegate.currentPanelsDimensions().leftPanelWidth ?? 0
//
//        while abs(leftWidth-width) >= 10 {
//
//
//        }
//
//        animatingSnap = false
//    }
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if sender.state == .began {
            
            self.initialLeftPanelViewWidth = currentPanelsDimensions.leftPanelWidth ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        var animated = false
        
        //standard resizing
        var mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        // do not allow resizing the left the window
        if initialLeftPanelViewWidth + mouseLocationDifference < 0 {
            
            mouseLocationDifference = -initialLeftPanelViewWidth
        }
        
        if magneticWhileResizing {
            
            let width = initialLeftPanelViewWidth + mouseLocationDifference
            
            //magnetic towards default width
            let defaultWidthDifference = width - leftPanel.defaultWidth
            let absoluteDefaultWidthDifference = abs(defaultWidthDifference)
            
            if absoluteDefaultWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference -= defaultWidthDifference
                
                if (currentPanelsDimensions.leftPanelWidth ?? 0 ) != leftPanel.defaultWidth {
                    
//                    animate(to: leftPanel.defaultWidth, from: sender)
                    print("snapped to default width \(width)")
                }
            }
            
            //magnetic towards hidden width
            let hiddenWidthDifference = width - 0 //0 is a hidden width
            let absoluteHiddenWidthDifference = abs(hiddenWidthDifference)
            
            if absoluteHiddenWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference -= hiddenWidthDifference
                
                if (currentPanelsDimensions.leftPanelWidth ?? 0) != 0 {
                    
//                    animate(to: 0, from: sender)
                    print("snapped to hidden width \(width)")
                }
            }
            
            if (currentPanelsDimensions.leftPanelWidth ?? 0) == leftPanel.defaultWidth && (initialLeftPanelViewWidth + mouseLocationDifference) != leftPanel.defaultWidth {
                
                print("snapped away from default width")
            }
            
            if (currentPanelsDimensions.leftPanelWidth ?? 0) == 0 && (initialLeftPanelViewWidth + mouseLocationDifference) != 0{
                
                print("snapped away from hidden width")
            }
        }
        
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let newFrame = NSRect(x: frame.minX,
                              y: frame.minY,
                              width: self.initialResizingFrame.width + mouseLocationDifference,
                              height: frame.height)
        
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: initialLeftPanelViewWidth + mouseLocationDifference,
                                                rightPanelWidth: currentPanelsDimensions.rightPanelWidth)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: animated)
        
        //auto-hide/show
        if sender.state == .ended {
            
            animated = true
            
            //hide
            if currentPanelsDimensions.leftPanelWidth ?? 0 < leftPanel.hidingThreshold {
                
                //calculate new frame
                var newFrame: NSRect = .zero
                if let frame = currentPanelsDimensions.windowFrame {
                    
                    let widthToSubtract = currentPanelsDimensions.leftPanelWidth ?? 0
                    
                    let newOrigin = NSPoint(x: frame.minX, y: frame.minY)
                    let newSize = NSSize(width: frame.width - widthToSubtract, height: frame.height)
                    newFrame = NSRect(origin: newOrigin, size: newSize)
                }
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                        leftPanelWidth: 0,
                                                        rightPanelWidth: currentPanelsDimensions.rightPanelWidth)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: animated)
            }
                //show
            else if (currentPanelsDimensions.leftPanelWidth ?? 0) < leftPanel.defaultWidth {
                
                //calculate new frame
                var newFrame: NSRect = .zero
                if let frame = currentPanelsDimensions.windowFrame {
                    
                    let widthToAdd = leftPanel.defaultWidth - (currentPanelsDimensions.leftPanelWidth ?? 0)
                    
                    let newOrigin = NSPoint(x: frame.minX, y: frame.minY)
                    let newSize = NSSize(width: frame.width + widthToAdd, height: frame.height)
                    newFrame = NSRect(origin: newOrigin, size: newSize)
                }
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                        leftPanelWidth: leftPanel.defaultWidth,
                                                        rightPanelWidth: currentPanelsDimensions.rightPanelWidth)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: animated)
            }
        }
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if sender.state == .began {
            
            self.initialRightPanelViewWidth = currentPanelsDimensions.rightPanelWidth ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        //standard resizing
        var mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        //do not allow resizing to the right of the window
        if initialRightPanelViewWidth - mouseLocationDifference < 0 {
            
            mouseLocationDifference -= (mouseLocationDifference - initialRightPanelViewWidth)
        }
        
        if magneticWhileResizing {
            
            let width = initialRightPanelViewWidth - mouseLocationDifference
            
            //magnetic towards default width
            let defaultWidthDifference = width - rightPanel.defaultWidth
            let absoluteDefaultWidthDifference = abs(defaultWidthDifference)
            
            if absoluteDefaultWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference += defaultWidthDifference
            }
            
            //magnetic towards hidden width
            let hiddenWidthDifference = width - 0 //0 is a hidden width
            let absoluteHiddenWidthDifference = abs(hiddenWidthDifference)
            
            if absoluteHiddenWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference += hiddenWidthDifference
            }
        }
        
        var newFrame: NSRect?
        if let frame = currentPanelsDimensions.windowFrame {
            
            newFrame = NSRect(x: self.initialResizingFrame.minX + mouseLocationDifference,
                                  y: frame.minY,
                                  width: self.initialResizingFrame.width - mouseLocationDifference,
                                  height: frame.height)
        }
        
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: nil,
                                                rightPanelWidth: initialRightPanelViewWidth - mouseLocationDifference)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        //auto-hide/show
        if sender.state == .ended {
            
            //hide
            if (currentPanelsDimensions.rightPanelWidth ?? 0) < rightPanel.hidingThreshold {
                
                //calculate new frame
                var newFrame: NSRect = .zero
                if let frame = currentPanelsDimensions.windowFrame {
                    
                    let widthToSubtract = (currentPanelsDimensions.rightPanelWidth ?? 0)
                    
                    let newOrigin = NSPoint(x: frame.minX + widthToSubtract, y: frame.minY)
                    let newSize = NSSize(width: frame.width - widthToSubtract, height: frame.height)
                    newFrame = NSRect(origin: newOrigin, size: newSize)
                }
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                        leftPanelWidth: currentPanelsDimensions.leftPanelWidth,
                                                        rightPanelWidth: 0)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
            //show
            else if (currentPanelsDimensions.rightPanelWidth ?? 0) < rightPanel.defaultWidth {
                
                //calculate new frame
                var newFrame: NSRect = .zero
                if let frame = currentPanelsDimensions.windowFrame {
                    
                    let widthToAdd = rightPanel.defaultWidth - (currentPanelsDimensions.rightPanelWidth ?? 0)
                    
                    let newOrigin = NSPoint(x: frame.minX - widthToAdd, y: frame.minY)
                    let newSize = NSSize(width: frame.width + widthToAdd, height: frame.height)
                    newFrame = NSRect(origin: newOrigin, size: newSize)
                }
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                        leftPanelWidth: currentPanelsDimensions.leftPanelWidth,
                                                        rightPanelWidth: rightPanel.defaultWidth)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
        }
    }
}
