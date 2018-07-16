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
        self.handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: leftPanel)
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let resizeHandler = RightResizingHandler()
        self.handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: rightPanel)
    }
    
    private func handlePanelResize(gesture: NSPanGestureRecognizer, resizeHandler: HorizontalResizingHandler, panel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if gesture.state == .began {
            
            self.configureForPanelResizing()
            return
        }
        
        let windowFrame = self.calcWindowFrame(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let leftPanelWidth = resizeHandler.calcLeftPanelWidth(initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let rightPanelWidth = resizeHandler.calcRightPanelWidth(initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let panelsDimensions = PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: leftPanelWidth, rightPanelWidth: rightPanelWidth)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        if gesture.state == .ended {
            
            self.handleEndOfPanelResizing(horizontalResizingHandler: resizeHandler, panel: panel, currentPanelsDimensions: currentPanelsDimensions)
        }
    }
    
    private func configureForPanelResizing() {
        
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
        self.initialMouseLocation = NSEvent.mouseLocation
        self.delegate.setStandardResizing(true)
    }
    
    private func calcWindowFrame(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> NSRect {
        
        let mouseLocationDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = horizontalResizingHandler.calcWindowWidth(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = horizontalResizingHandler.calcWindowXCoordinate(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinate: currentMouseXCoordinate, mouseXCoordinateDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        return newFrame
    }
    
    // MARK: auto hide/show
    private func handleEndOfPanelResizing(horizontalResizingHandler: HorizontalResizingHandler, panel: Panel, currentPanelsDimensions: PanelsDimensions) {
        
        let panelWidth = horizontalResizingHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
        
        let shouldHidePanel = (panelWidth > 0) && (panelWidth <= panel.hidingThreshold)
        let shouldExpandPanel = (panelWidth > panel.hidingThreshold) && (panelWidth < panel.defaultWidth)
        let shouldBounceBackFromElasticity = panelWidth == 0
        
        if shouldHidePanel || shouldExpandPanel {
            
            self.setPanelHidden(hidden: shouldHidePanel, panel: panel, animated: true, horizontalResizingHandler: horizontalResizingHandler)
        }
        else if shouldBounceBackFromElasticity {
            
            guard let elasticEndFrame = horizontalResizingHandler.calcElasticEndFrame(initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinate: NSEvent.mouseLocation.x) else {
                
                return
            }
            
            self.delegate.didUpdate(panelsDimensions: elasticEndFrame, animated: true)
        }
    }
    
    private func setPanelHidden(hidden: Bool, panel: Panel, animated: Bool, horizontalResizingHandler: HorizontalResizingHandler) {
        
        // origin
        let newXCoordinate = horizontalResizingHandler.calcWindowXCoordinate(hidden: hidden, initialPanelDimensions: self.initialPanelsDimensions, defaultWidth: panel.defaultWidth)
        let newYCoordinate = (self.initialPanelsDimensions.windowFrame?.minY ?? 0)
        let newOrigin = NSPoint(x: newXCoordinate, y: newYCoordinate)
        
        // size
        let newSize = self.calcNewSize(hidden: hidden, horizontalResizingHandler: horizontalResizingHandler, panel: panel)
        
        // panelsDimensions
        let newFrame = NSRect(origin: newOrigin, size: newSize)
        let panelsDimensions = horizontalResizingHandler.calcPanelsDimensions(hidden: hidden, windowFrame: newFrame, defaultWidth: panel.defaultWidth)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: animated)
    }
    
    private func calcNewSize(hidden: Bool, horizontalResizingHandler: HorizontalResizingHandler, panel: Panel) -> NSSize {
        
        let height = (self.initialPanelsDimensions.windowFrame?.height ?? 0)
        
        let widthWithoutPanel = (self.initialPanelsDimensions.windowFrame?.width ?? 0) - (horizontalResizingHandler.relevantPanelWidth(panelsDimensions: self.initialPanelsDimensions) ?? 0)
        let width = hidden ? widthWithoutPanel : widthWithoutPanel + panel.defaultWidth
        
        return NSSize(width: width, height: height)
    }
    
    // MARK: - Window Resizing
    func didStartWindowResize(_ sides: [Side]) {
        
        self.initialMouseLocation = NSEvent.mouseLocation
        self.resizingSides = sides
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
    }
    
    func didEndWindowResize(minimumSize: NSSize) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        let bufferEdge: CGFloat = 1
        
        let widthSmallerThanMinimumSize = (currentPanelsDimensions.windowFrame?.width ?? 0) <= (minimumSize.width + bufferEdge)
        let heightSmallerThanMinimumSize = (currentPanelsDimensions.windowFrame?.height ?? 0) <= (minimumSize.height + bufferEdge)
        
        var newXCoordinate = (currentPanelsDimensions.windowFrame?.minX ?? 0)
        var newYCoordinate = (currentPanelsDimensions.windowFrame?.minY ?? 0)
        
        if widthSmallerThanMinimumSize {
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
            
            newXCoordinate = horizontalResizingHandler.clacWindowXCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        if heightSmallerThanMinimumSize {

            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()

            newYCoordinate = verticalResizingHandler.clacWindowYCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        if widthSmallerThanMinimumSize || heightSmallerThanMinimumSize {
            let newFrame = NSRect(x: newXCoordinate,
                                  y: newYCoordinate,
                                  width: (currentPanelsDimensions.windowFrame?.width ?? 0),
                                  height: (currentPanelsDimensions.windowFrame?.height ?? 0))
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
        }
    }
        
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let width = max(minimumSize.width, frameSize.width)
        let height = max(minimumSize.height, frameSize.height)
        
        let frameWidthSmallerThanMinimumWidth = frameSize.width < minimumSize.width
        let frameHeightSmallerThanMinimumHeight = frameSize.height < minimumSize.height
        
        // if attempting to resize to a width smaller than allowed - move window frame instead (elastically)
        if frameWidthSmallerThanMinimumWidth || frameHeightSmallerThanMinimumHeight {
            
            self.delegate.setStandardResizing(false)
            
            var newX: CGFloat = (self.delegate.currentPanelsDimensions().windowFrame?.minX ?? 0)
            var newY: CGFloat = (self.delegate.currentPanelsDimensions().windowFrame?.minY ?? 0)
            
            if frameWidthSmallerThanMinimumWidth {
                
                let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
                
                let mouseXCoordinateToEdgeDifference = width - frameSize.width
                let elasticDifferenceX = pow(abs(mouseXCoordinateToEdgeDifference), 0.7)
                
                let widthDifference = horizontalResizingHandler.calcWidthDifference(initialPanelsDimensions: self.initialPanelsDimensions, minimumSize: minimumSize)
                newX = horizontalResizingHandler.calcWindowXCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, widthDifference: widthDifference, elasticDifference: elasticDifferenceX)
            }
            else {
                
                if resizingSides.contains(.left) {
                    
                    newX = (initialPanelsDimensions.windowFrame?.minX ?? 0) - (frameSize.width - (self.initialPanelsDimensions.windowFrame?.width ?? 0))
                }
            }
            
            if frameHeightSmallerThanMinimumHeight {
                
                let mouseYCoordinateToEdgeDifference = height - frameSize.height
                let elasticDifferenceY = pow(abs(mouseYCoordinateToEdgeDifference), 0.7)
                
                let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
                
                newY = verticalResizingHandler.calcWindowYCoordinate(initialPanelsDimensions: self.initialPanelsDimensions, newFrameSize: frameSize, elasticDifference: elasticDifferenceY, minimumSize: minimumSize)
            }
            else {
                
                if resizingSides.contains(.bottom) {
                    
                    newY = (initialPanelsDimensions.windowFrame?.minY ?? 0) - (frameSize.height - (self.initialPanelsDimensions.windowFrame?.height ?? 0))
                }
            }
            
            
            let newFrame = NSRect(x: newX, y: newY, width: width, height: height)
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        }
        else {
            
            self.delegate.setStandardResizing(true)
            return frameSize
        }

        return NSSize(width: width, height: height)
    }
}
