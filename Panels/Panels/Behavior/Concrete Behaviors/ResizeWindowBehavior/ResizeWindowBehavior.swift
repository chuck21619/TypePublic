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
    
    private var initialMouseLocation: NSPoint = .zero
    private var initialPanelsDimensions = PanelsDimensions(windowFrame: nil, leftPanelWidth: nil, rightPanelWidth: nil)
    private var animatingSnap = false
    private var resizingSides: [Side] = []
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
    // MARK: - Panel Resizing
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let resizeHandler = LeftResizingHandler()
        handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: leftPanel)
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let resizeHandler = RightResizingHandler()
        handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: rightPanel)
    }
    
    func handlePanelResize(gesture: NSPanGestureRecognizer, resizeHandler: HorizontalResizingHandler, panel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if gesture.state == .began {
            
            self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
            self.initialMouseLocation = NSEvent.mouseLocation
            self.delegate.setStandardResizing(true)
            return
        }
        
        let newFrame = resizeHandler.calcWindowFrame(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let leftPanelWidth = resizeHandler.calcLeftPanelWidth(initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let rightPanelWidth = resizeHandler.calcRightPanelWidth(initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: leftPanelWidth,
                                                rightPanelWidth: rightPanelWidth)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        if gesture.state == .ended {
            
            let panelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            
            //animate panel hidden when under threshold
            if panelWidth > 0 {
                
                let frame = currentPanelsDimensions.windowFrame ?? .zero
                
                if panelWidth < panel.hidingThreshold {
                    
                    let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToSubtract: panelWidth)
                    let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                    let newSize = NSSize(width: frame.width - panelWidth, height: frame.height)
                    let newFrame = NSRect(origin: newOrigin, size: newSize)
                    
                    let panelsDimensions = resizeHandler.calcHiddenPanelPanelsDimensions(windowFrame: newFrame)
                    self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
                }
                    //animate panel to default width when within threshold
                else if panelWidth < panel.defaultWidth {
                    
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
        }
    }
    
    // MARK: - Window Resizing
    func didStartWindowResize(_ sides: [Side]) {
        
        self.initialMouseLocation = NSEvent.mouseLocation
        self.resizingSides = sides
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
    }
    
    func didEndWindowResize(minimumSize: NSSize) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        let bufferWidth: CGFloat = 1
        
        if (currentPanelsDimensions.windowFrame?.width ?? 0) <= (minimumSize.width + bufferWidth) {
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
//            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
            
            let newXCoordinate = horizontalResizingHandler.clacWindowXCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
            let newFrame = NSRect(x: newXCoordinate,
                                  y: (currentPanelsDimensions.windowFrame?.minY ?? 0),
                                  width: (currentPanelsDimensions.windowFrame?.width ?? 0),
                                  height: (currentPanelsDimensions.windowFrame?.height ?? 0))
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
        }
    }
        
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let width = max(minimumSize.width, frameSize.width)
        
        // if attempting to resize to a width smaller than allowed - move window frame instead (elastically)
        if frameSize.width < minimumSize.width {
            
            self.delegate.setStandardResizing(false)
            
            let mouseXCoordinateToSideEdgeDifference = width - frameSize.width
            let elasticDifference = pow(abs(mouseXCoordinateToSideEdgeDifference), 0.7)
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
            
            let newY = verticalResizingHandler.calcWindowYCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, newFrameSize: frameSize)
            
            let widthDifference = horizontalResizingHandler.calcWidthDifference(initialPanelsDimensions: self.initialPanelsDimensions, minimumSize: minimumSize)
            let newX = horizontalResizingHandler.calcWindowXCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, widthDifference: widthDifference, elasticDifference: elasticDifference)
            
            let newFrame = NSRect(x: newX, y: newY, width: width, height: frameSize.height)
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        }
        else {
            
            self.delegate.setStandardResizing(true)
            return frameSize
        }

        return NSSize(width: width, height: frameSize.height)
    }
}
