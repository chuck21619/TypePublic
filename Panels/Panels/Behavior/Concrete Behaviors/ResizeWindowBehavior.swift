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
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if sender.state == .began {
            
            self.initialLeftPanelViewWidth = currentPanelsDimensions.leftPanelWidth ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        //standard resizing
        var mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        if initialLeftPanelViewWidth + mouseLocationDifference < 0 {
            
            mouseLocationDifference = -initialLeftPanelViewWidth
        }
        
        var newFrame: NSRect?
        if let frame = currentPanelsDimensions.windowFrame {
            
            newFrame = NSRect(x: frame.minX,
                                  y: frame.minY,
                                  width: self.initialResizingFrame.width + mouseLocationDifference,
                                  height: frame.height)
        }
        
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: initialLeftPanelViewWidth + mouseLocationDifference,
                                                rightPanelWidth: currentPanelsDimensions.rightPanelWidth)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        
        //auto-hide/show
        if sender.state == .ended {
            
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
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
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
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
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
        
        if initialRightPanelViewWidth - mouseLocationDifference < 0 {
            
            mouseLocationDifference -= (mouseLocationDifference - initialRightPanelViewWidth)
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
