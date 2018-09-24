//
//  ResizingCalculator.swift
//  Panels
//
//  Created by charles johnston on 7/17/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class ResizingCalculator {
    
    let bufferEdge: CGFloat = 1
    let elasticity: CGFloat = 0.7
    
    // MARK: - Panel Resizing
    func panelResizingWindowFrame(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> NSRect {
        
        let mouseLocationDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = horizontalResizingHandler.panelResizingWindowWidth(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = panelResizingXCoordinate(horizontalResizingHandler: horizontalResizingHandler, initialPanelsDimensions: initialPanelsDimensions, currentMouseXCoordinate: currentMouseXCoordinate, mouseLocationDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        return newFrame
    }
    
    private func panelResizingXCoordinate(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, currentMouseXCoordinate: CGFloat, mouseLocationDifference: CGFloat) -> CGFloat {
        
        let nonElasticXCoordinate = horizontalResizingHandler.panelResizingNonElasticXCoordinate(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinateDifference: mouseLocationDifference)
        
        let mouseToEdgeDifference = horizontalResizingHandler.panelResizingMouseToEdgeDifference(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinate: currentMouseXCoordinate)
        
        if horizontalResizingHandler.panelResizingMouseIsPassedWindowEdge(mouseToEdgeDifference: mouseToEdgeDifference) {
            return nonElasticXCoordinate
        }
        
        let elasticDifference = pow(abs(mouseToEdgeDifference), elasticity)
        let elasticXCoordinate = horizontalResizingHandler.panelResizingElasticXCoordinate(nonElasticCoordinate: nonElasticXCoordinate, elasticDifference: elasticDifference)
        
        return elasticXCoordinate
    }
    
    func panelResizingLeftPanelWidth(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let leftPanelWidth = horizontalResizingHandler.panelResizingLeftPanelWidth(initialPanelsDimensions: initialPanelsDimensions, initialMouseXCoordinate: initialMouseXCoordinate, currentMouseXCoordinate: currentMouseXCoordinate)
        
        return leftPanelWidth
    }
    
    func panelResizingRightPanelWidth(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let rightPanelWidth = horizontalResizingHandler.panelResizingRightPanelWidth(initialPanelsDimensions: initialPanelsDimensions, initialMouseXCoordinate: initialMouseXCoordinate, currentMouseXCoordinate: currentMouseXCoordinate)
        
        return rightPanelWidth
    }
    
    func shouldHidePanel(panelWidth: CGFloat, panel: Panel) -> Bool {
        return (panelWidth > 0) && (panelWidth <= panel.hidingThreshold)
    }
    
    func shouldExpandPanel(panelWidth: CGFloat, panel: Panel) -> Bool {
        return (panelWidth > panel.hidingThreshold) && (panelWidth < panel.defaultWidth)
    }
    
    func shouldBounceBackFromElasticity(panelWidth: CGFloat) -> Bool {
        return panelWidth == 0
    }
    
    func panelResizingHiddenPanelPanelsDimensions(panel: Panel, hidden: Bool, horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions) -> PanelsDimensions {
        
        // origin
        let newXCoordinate = horizontalResizingHandler.panelResizingHiddenPanelWindowXCoordinate(hidden: hidden, initialPanelDimensions: initialPanelsDimensions, defaultWidth: panel.defaultWidth)
        let newYCoordinate = (initialPanelsDimensions.windowFrame?.minY ?? 0)
        let newOrigin = NSPoint(x: newXCoordinate, y: newYCoordinate)
        
        // size
        let newSize = self.panelResizingWindowSizeForHiddenPanel(hidden: hidden, horizontalResizingHandler: horizontalResizingHandler, panel: panel, initialPanelsDimensions: initialPanelsDimensions)
        
        // panelsDimensions
        let newFrame = NSRect(origin: newOrigin, size: newSize)
        let panelsDimensions = horizontalResizingHandler.panelResizingHiddenPanelPanelsDimensions(hidden: hidden, windowFrame: newFrame, defaultWidth: panel.defaultWidth)
        
        return panelsDimensions
    }
    
    private func panelResizingWindowSizeForHiddenPanel(hidden: Bool, horizontalResizingHandler: HorizontalResizingHandler, panel: Panel, initialPanelsDimensions: PanelsDimensions) -> NSSize {
        
        let height = (initialPanelsDimensions.windowFrame?.height ?? 0)
        
        let widthWithoutPanel = (initialPanelsDimensions.windowFrame?.width ?? 0) - (horizontalResizingHandler.relevantPanelWidth(panelsDimensions: initialPanelsDimensions) ?? 0)
        let width = hidden ? widthWithoutPanel : widthWithoutPanel + panel.defaultWidth
        
        return NSSize(width: width, height: height)
    }
    
    // MARK: - Window Resizing
    func windowResizingFrame(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, minimumSize: NSSize, resizingSides: [Side]) -> NSRect {
        
        let shouldCalculateElastically = self.windowResizingShouldCalculateElastically(frameSize: (currentPanelsDimensions.windowFrame?.size ?? .zero), minimumSize: minimumSize)
        
        var newXCoordinate = (currentPanelsDimensions.windowFrame?.minX ?? 0)
        var newYCoordinate = (currentPanelsDimensions.windowFrame?.minY ?? 0)
        
        if shouldCalculateElastically.x {
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
            newXCoordinate = horizontalResizingHandler.windowResizingXCoordinate(initialPanelsDimensions: initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        if shouldCalculateElastically.y {
            
            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
            newYCoordinate = verticalResizingHandler.clacWindowYCoordinate(initialPanelsDimensions: initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        let newOrigin = NSPoint(x: newXCoordinate, y: newYCoordinate)
        let size = NSSize(width: (currentPanelsDimensions.windowFrame?.width ?? 0), height: (currentPanelsDimensions.windowFrame?.height ?? 0))
        let newFrame = NSRect(origin: newOrigin, size: size)
        
        return newFrame
    }
    
    private func windowResizeSize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let width = max(minimumSize.width, frameSize.width)
        let height = max(minimumSize.height, frameSize.height)
        let newSize = NSSize(width: width, height: height)
        
        return newSize
    }
    
    func windowResizingShouldCalculateElastically(frameSize: NSSize, minimumSize: NSSize) -> (x: Bool, y: Bool) {
        
        let shouldCalculateXAxisElastically = frameSize.width <= minimumSize.width
        let shouldCalculateYAxisElastically = frameSize.height <= minimumSize.height
        
        return (x: shouldCalculateXAxisElastically, y: shouldCalculateYAxisElastically)
    }
    
    func windowResizingElasticFrame(shouldCalculateXAxisElastically: Bool, frameSize: NSSize, minimumSize: NSSize, shouldCalculateYAxisElastically: Bool, currentPanelsDimensions: PanelsDimensions, initialPanelsDimensions: PanelsDimensions, resizingSides: [Side]) -> NSRect {
        
        let size = self.windowResizeSize(frameSize: frameSize, minimumSize: minimumSize)
        let origin = self.windowResizingElasticOrigin(shouldCalculateXAxisElastically: shouldCalculateXAxisElastically, width: size.width, frameSize: frameSize, minimumSize: minimumSize, shouldCalculateYAxisElastically: shouldCalculateYAxisElastically, height: size.height, currentPanelsDimensions: currentPanelsDimensions, initialPanelsDimensions: initialPanelsDimensions, resizingSides: resizingSides)
        let frame = NSRect(origin: origin, size: size)
        
        return frame
    }
    
    private func windowResizingElasticCoordinate(axis: Axis, shouldCalculateElastically: Bool, size: CGFloat, frameSize: NSSize, minimumSize: NSSize, currentPanelsDimensions: PanelsDimensions, initialPanelsDimensions: PanelsDimensions, resizingSides: [Side]) -> CGFloat {
        
        var newAxisOrigin = axis.origin(rect: (currentPanelsDimensions.windowFrame ?? .zero))
        
        if shouldCalculateElastically {
            
            let mouseToEdgeDifference = size - axis.size(size: frameSize)
            let elasticDifference = pow(abs(mouseToEdgeDifference), elasticity)
            
            newAxisOrigin = axis.elasticOrigin(resizingSides: resizingSides, initialPanelsDimensions: initialPanelsDimensions, newFrameSize: frameSize, elasticDifference: elasticDifference, mininumSize: minimumSize)
        }
        else {
            
            if axis.containsOriginSide(sides: resizingSides) {
                
                newAxisOrigin = (axis.origin(rect: (initialPanelsDimensions.windowFrame ?? .zero))) - (axis.size(size: frameSize) - (axis.size(size: (initialPanelsDimensions.windowFrame?.size ?? .zero))))
            }
        }
        
        return newAxisOrigin
    }
    
    private func windowResizingElasticOrigin(shouldCalculateXAxisElastically: Bool, width: CGFloat, frameSize: NSSize, minimumSize: NSSize, shouldCalculateYAxisElastically: Bool, height: CGFloat, currentPanelsDimensions: PanelsDimensions, initialPanelsDimensions: PanelsDimensions, resizingSides: [Side]) -> NSPoint {
        
        let newX = windowResizingElasticCoordinate(axis: X(), shouldCalculateElastically: shouldCalculateXAxisElastically, size: width, frameSize: frameSize, minimumSize: minimumSize, currentPanelsDimensions: currentPanelsDimensions, initialPanelsDimensions: initialPanelsDimensions, resizingSides: resizingSides)
        
        let newY = windowResizingElasticCoordinate(axis: Y(), shouldCalculateElastically: shouldCalculateYAxisElastically, size: height, frameSize: frameSize, minimumSize: minimumSize, currentPanelsDimensions: currentPanelsDimensions, initialPanelsDimensions: initialPanelsDimensions, resizingSides: resizingSides)
        
        return NSPoint(x: newX, y: newY)
    }
}
