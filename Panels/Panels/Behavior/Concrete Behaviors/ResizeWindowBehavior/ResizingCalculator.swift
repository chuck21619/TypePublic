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
    
    func calcWindowFrame(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> NSRect {
        
        let mouseLocationDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = horizontalResizingHandler.calcWindowWidth(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = horizontalResizingHandler.calcWindowXCoordinate(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinate: currentMouseXCoordinate, mouseXCoordinateDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        return newFrame
    }
    
    func calcLeftPanelWidth(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let leftPanelWidth = horizontalResizingHandler.calcLeftPanelWidth(initialPanelsDimensions: initialPanelsDimensions, initialMouseXCoordinate: initialMouseXCoordinate, currentMouseXCoordinate: currentMouseXCoordinate)
        
        return leftPanelWidth
    }
    
    func calcRightPanelWidth(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let rightPanelWidth = horizontalResizingHandler.calcRightPanelWidth(initialPanelsDimensions: initialPanelsDimensions, initialMouseXCoordinate: initialMouseXCoordinate, currentMouseXCoordinate: currentMouseXCoordinate)
        
        return rightPanelWidth
    }
    
    //auto hide/show
    func shouldHidePanel(_ panelWidth: CGFloat, _ panel: Panel) -> Bool {
        return (panelWidth > 0) && (panelWidth <= panel.hidingThreshold)
    }
    
    func shouldExpandPanel(_ panelWidth: CGFloat, _ panel: Panel) -> Bool {
        return (panelWidth > panel.hidingThreshold) && (panelWidth < panel.defaultWidth)
    }
    
    func shouldBounceBackFromElasticity(_ panelWidth: CGFloat) -> Bool {
        return panelWidth == 0
    }
    
    func elasticEndFrame(horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        return horizontalResizingHandler.calcElasticEndFrame(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinate: mouseXCoordinate)
    }
    
    func panelsDimensions(panel: Panel, hidden: Bool, horizontalResizingHandler: HorizontalResizingHandler, initialPanelsDimensions: PanelsDimensions) -> PanelsDimensions {
        
        // origin
        let newXCoordinate = horizontalResizingHandler.calcWindowXCoordinate(hidden: hidden, initialPanelDimensions: initialPanelsDimensions, defaultWidth: panel.defaultWidth)
        let newYCoordinate = (initialPanelsDimensions.windowFrame?.minY ?? 0)
        let newOrigin = NSPoint(x: newXCoordinate, y: newYCoordinate)
        
        // size
        let newSize = self.calcNewSize(hidden: hidden, horizontalResizingHandler: horizontalResizingHandler, panel: panel, initialPanelsDimensions: initialPanelsDimensions)
        
        // panelsDimensions
        let newFrame = NSRect(origin: newOrigin, size: newSize)
        let panelsDimensions = horizontalResizingHandler.calcPanelsDimensions(hidden: hidden, windowFrame: newFrame, defaultWidth: panel.defaultWidth)
        
        return panelsDimensions
    }
    
    private func calcNewSize(hidden: Bool, horizontalResizingHandler: HorizontalResizingHandler, panel: Panel, initialPanelsDimensions: PanelsDimensions) -> NSSize {
        
        let height = (initialPanelsDimensions.windowFrame?.height ?? 0)
        
        let widthWithoutPanel = (initialPanelsDimensions.windowFrame?.width ?? 0) - (horizontalResizingHandler.relevantPanelWidth(panelsDimensions: initialPanelsDimensions) ?? 0)
        let width = hidden ? widthWithoutPanel : widthWithoutPanel + panel.defaultWidth
        
        return NSSize(width: width, height: height)
    }
    
    //window resizing
    func windowResizingWidthIsLessThanMinimumWidth(_ currentPanelsDimensions: PanelsDimensions, _ minimumSize: NSSize) -> Bool {
        return (currentPanelsDimensions.windowFrame?.width ?? 0) <= (minimumSize.width + self.bufferEdge)
    }
    
    func windowResizingHeightIsLessThanMinimumHeight(_ currentPanelsDimensions: PanelsDimensions, _ minimumSize: NSSize) -> Bool {
        return (currentPanelsDimensions.windowFrame?.height ?? 0) <= (minimumSize.height + self.bufferEdge)
    }
    
    func calcWindowResizingCoordinates(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, minimumSize: NSSize, resizingSides: [Side]) -> NSRect {
        
        let widthSmallerThanMinimumSize = self.windowResizingWidthIsLessThanMinimumWidth(currentPanelsDimensions, minimumSize)
        let heightSmallerThanMinimumSize = self.windowResizingHeightIsLessThanMinimumHeight(currentPanelsDimensions, minimumSize)
        
        var newXCoordinate = (currentPanelsDimensions.windowFrame?.minX ?? 0)
        var newYCoordinate = (currentPanelsDimensions.windowFrame?.minY ?? 0)
        
        if widthSmallerThanMinimumSize {
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
            
            newXCoordinate = horizontalResizingHandler.clacWindowXCoordinate(initialPanelsDimensions: initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        if heightSmallerThanMinimumSize {
            
            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
            
            newYCoordinate = verticalResizingHandler.clacWindowYCoordinate(initialPanelsDimensions: initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions)
        }
        
        let newOrigin = NSPoint(x: newXCoordinate, y: newYCoordinate)
        let size = NSSize(width: (currentPanelsDimensions.windowFrame?.width ?? 0),
                          height: (currentPanelsDimensions.windowFrame?.height ?? 0))
        let newFrame = NSRect(origin: newOrigin, size: size)
        return newFrame
    }
    
    func windowResizeSize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let width = max(minimumSize.width, frameSize.width)
        let height = max(minimumSize.height, frameSize.height)
        let newSize = NSSize(width: width, height: height)
        
        return newSize
    }
    
    func shouldCalculateAxesElastically(_ frameSize: NSSize, _ minimumSize: NSSize) -> (x: Bool, y: Bool) {
        
        let shouldCalculateXCoordinateElastically = frameSize.width < minimumSize.width
        let shouldCalculateYCoordinateElastically = frameSize.height < minimumSize.height
        
        return (x: shouldCalculateXCoordinateElastically, y: shouldCalculateYCoordinateElastically)
    }
    
    
    private func calcElasticXCoordinate(_ frameWidthSmallerThanMinimumWidth: Bool, _ width: CGFloat, _ frameSize: NSSize, _ minimumSize: NSSize, _ currentPanelsDimensions: PanelsDimensions, _ initialPanelsDimensions: PanelsDimensions, _ resizingSides: [Side]) -> CGFloat {
        
        var newX: CGFloat = (currentPanelsDimensions.windowFrame?.minX ?? 0)
        
        if frameWidthSmallerThanMinimumWidth {
            
            let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
            
            let mouseXCoordinateToEdgeDifference = width - frameSize.width
            let elasticDifferenceX = pow(abs(mouseXCoordinateToEdgeDifference), 0.7)
            
            let widthDifference = horizontalResizingHandler.calcWidthDifference(initialPanelsDimensions: initialPanelsDimensions, minimumSize: minimumSize)
            newX = horizontalResizingHandler.calcWindowXCoordinate(initialPanelsDimensions: initialPanelsDimensions, widthDifference: widthDifference, elasticDifference: elasticDifferenceX)
        }
        else {
            
            if resizingSides.contains(.left) {
                
                newX = (initialPanelsDimensions.windowFrame?.minX ?? 0) - (frameSize.width - (initialPanelsDimensions.windowFrame?.width ?? 0))
            }
        }
        
        return newX
    }
    
    private func calcElasticYCoordinate(_ frameHeightSmallerThanMinimumHeight: Bool, _ height: CGFloat, _ frameSize: NSSize, _ minimumSize: NSSize, _ currentPanelsDimensions: PanelsDimensions, _ initialPanelsDimensions: PanelsDimensions, _ resizingSides: [Side]) -> CGFloat {
        
        var newY: CGFloat = (currentPanelsDimensions.windowFrame?.minY ?? 0)
        
        if frameHeightSmallerThanMinimumHeight {
            
            let mouseYCoordinateToEdgeDifference = height - frameSize.height
            let elasticDifferenceY = pow(abs(mouseYCoordinateToEdgeDifference), 0.7)
            
            let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
            
            newY = verticalResizingHandler.calcWindowYCoordinate(initialPanelsDimensions: initialPanelsDimensions, newFrameSize: frameSize, elasticDifference: elasticDifferenceY, minimumSize: minimumSize)
        }
        else {
            
            if resizingSides.contains(.bottom) {
                
                newY = (initialPanelsDimensions.windowFrame?.minY ?? 0) - (frameSize.height - (initialPanelsDimensions.windowFrame?.height ?? 0))
            }
        }
        
        return newY
    }
    
    func calcElasticOrigin(_ frameWidthSmallerThanMinimumWidth: Bool, _ width: CGFloat, _ frameSize: NSSize, _ minimumSize: NSSize, _ frameHeightSmallerThanMinimumHeight: Bool, _ height: CGFloat, _ currentPanelsDimensions: PanelsDimensions, _ initialPanelsDimensions: PanelsDimensions, _ resizingSides: [Side]) -> NSPoint {
        
        let newX = calcElasticXCoordinate(frameWidthSmallerThanMinimumWidth, width, frameSize, minimumSize, currentPanelsDimensions, initialPanelsDimensions, resizingSides)
        
        let newY = calcElasticYCoordinate(frameHeightSmallerThanMinimumHeight, height, frameSize, minimumSize, currentPanelsDimensions, initialPanelsDimensions, resizingSides)
        
        return NSPoint(x: newX, y: newY)
    }
}
