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
    
    private var initialPanelWidth: CGFloat = 0
    private var initialResizingFrame: NSRect = .zero
    private var initialMouseLocation: NSPoint = .zero
    private var initialPanelsDimensions = PanelsDimensions(windowFrame: nil, leftPanelWidth: nil, rightPanelWidth: nil)
    private var animatingSnap = false
    private var resizingSides: [Side] = []
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let resizeHandler = LeftResizeHandler()
        handleResize(gesture: sender, resizeHandler: resizeHandler, panel: leftPanel)
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let resizeHandler = RightResizeHandler()
        handleResize(gesture: sender, resizeHandler: resizeHandler, panel: rightPanel)
    }
    
    func didStartWindowResize(_ sides: [Side]) {
        
        self.initialMouseLocation = NSEvent.mouseLocation
        self.resizingSides = sides
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
    }
    
    func didEndWindowResize(minimumSize: NSSize) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        let bufferWidth: CGFloat = 1
        
        if (currentPanelsDimensions.windowFrame?.width ?? 0) <= (minimumSize.width + bufferWidth) {
                
            if resizingSides.contains(.left) {
                
                let widthDifference = (initialPanelsDimensions.windowFrame?.width ?? 0) - (currentPanelsDimensions.windowFrame?.width ?? 0)
                let newXCoordinate = (self.initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference
                let newFrame = NSRect(x: newXCoordinate,
                                      y: (currentPanelsDimensions.windowFrame?.minY ?? 0),
                                      width: (currentPanelsDimensions.windowFrame?.width ?? 0),
                                      height: (currentPanelsDimensions.windowFrame?.height ?? 0))
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
            else {
                
                let newXCoordinate = (self.initialPanelsDimensions.windowFrame?.minX ?? 0)
                let newFrame = NSRect(x: newXCoordinate,
                                      y: (currentPanelsDimensions.windowFrame?.minY ?? 0),
                                      width: (currentPanelsDimensions.windowFrame?.width ?? 0),
                                      height: (currentPanelsDimensions.windowFrame?.height ?? 0))
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
        }
    }
        
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let width = max(minimumSize.width, frameSize.width)
        let currentPanelDimensions = self.delegate.currentPanelsDimensions()
        
        if frameSize.width < minimumSize.width {
            
            self.delegate.setStandardResizing(false)
            
            if resizingSides.contains(.left) {
                
                let mouseXCoordinateToLeftEdgeDifference = width - frameSize.width
                
                let elasticDifference = pow(abs(mouseXCoordinateToLeftEdgeDifference), 0.7)
                
                let widthDifference = (initialPanelsDimensions.windowFrame?.width ?? 0) - minimumSize.width
                
                var newY: CGFloat = 0
                if resizingSides.contains(.bottom) {
                    
                    let yToSubtract = frameSize.height - (self.initialPanelsDimensions.windowFrame?.height ?? 0)
                    newY = (self.initialPanelsDimensions.windowFrame?.minY ?? 0) - yToSubtract
                }
                else if resizingSides.contains(.top) {
                    
                    newY = (self.initialPanelsDimensions.windowFrame?.minY ?? 0)
                }
                
                let newFrame = NSRect(x: (self.initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference + elasticDifference,
                                      y: newY,
                                      width: width,
                                      height: frameSize.height)
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
            }
            else if resizingSides.contains(.right) {
                
                let mouseXCoordinateToRightEdgeDifference = width - frameSize.width
                
                let elasticDifference = pow(abs(mouseXCoordinateToRightEdgeDifference), 0.7)
                
                
                var newY: CGFloat = 0
                if resizingSides.contains(.bottom) {
                    
                    let yToSubtract = frameSize.height - (self.initialPanelsDimensions.windowFrame?.height ?? 0)
                    newY = (self.initialPanelsDimensions.windowFrame?.minY ?? 0) - yToSubtract
                }
                else if resizingSides.contains(.top) {
                    
                    newY = (self.initialPanelsDimensions.windowFrame?.minY ?? 0)
                }
                
                let newFrame = NSRect(x: (self.initialPanelsDimensions.windowFrame?.minX ?? 0) - elasticDifference,
                                      y: newY,
                                      width: width,
                                      height: frameSize.height)
                
                let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
                
            }
        }
        else {
            
            self.delegate.setStandardResizing(true)
            return frameSize
        }

        return NSSize(width: width, height: frameSize.height)
    }
    
    func handleResize(gesture: NSPanGestureRecognizer, resizeHandler: ResizeHandler, panel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if gesture.state == .began {
            
            self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
            self.initialPanelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        //standard resizing
        let mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        let panelsDimensions = newPanelsDimensions(currentPanelsDimensions: currentPanelsDimensions, resizeHandler: resizeHandler, mouseXCoordinate: NSEvent.mouseLocation.x, mouseXCoordinateDifference: mouseLocationDifference)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        if gesture.state == .ended {
            
            let panelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            
            //TODO: move auto-hide/show into resizeHandler?
            //animate panel hidden when under threshold
            if panelWidth > 0 {
                if panelWidth < panel.hidingThreshold {
                    
                    //calculate new frame
                    let frame = currentPanelsDimensions.windowFrame ?? .zero
                    
                    let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToSubtract: panelWidth)
                    let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                    let newSize = NSSize(width: frame.width - panelWidth, height: frame.height)
                    let newFrame = NSRect(origin: newOrigin, size: newSize)
                    
                    let panelsDimensions = resizeHandler.calcHiddenPanelPanelsDimensions(windowFrame: newFrame)
                    self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
                }
                    //animate panel to default width when within threshold
                else if panelWidth < panel.defaultWidth {
                    
                    //calculate new frame
                    let frame = currentPanelsDimensions.windowFrame ?? .zero
                    let widthToAdd = panel.defaultWidth - panelWidth
                    let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToAdd: widthToAdd)
                    let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                    let newSize = NSSize(width: frame.width + widthToAdd, height: frame.height)
                    let newFrame = NSRect(origin: newOrigin, size: newSize)
                    
                    let panelsDimensions = resizeHandler.calcDefaultPanelPanelsDimensions(windowFrame: newFrame, panel: panel)
                    self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
                }
            }
            else if panelWidth == 0, let elasticEndFrame = resizeHandler.calcElasticEndFrame(initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinate: NSEvent.mouseLocation.x) {
                
                self.delegate.didUpdate(panelsDimensions: elasticEndFrame, animated: true)
            }
            
            
            self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
            self.initialPanelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
        }
    }
    
    func newPanelsDimensions(currentPanelsDimensions: PanelsDimensions, resizeHandler: ResizeHandler, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> PanelsDimensions {
        
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = resizeHandler.calcWindowWidth(initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinateDifference: mouseXCoordinateDifference)
        let xCoordinate = resizeHandler.calcWindowXCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinate: NSEvent.mouseLocation.x, mouseXCoordinateDifference: mouseXCoordinateDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        let leftPanelWidth = resizeHandler.calcLeftPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseXCoordinateDifference)
        let rightPanelWidth = resizeHandler.calcRightPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseXCoordinateDifference)
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: leftPanelWidth,
                                                rightPanelWidth: rightPanelWidth)
        return panelsDimensions
    }
}
