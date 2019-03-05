//
//  RightResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class RightResizingHandler: HorizontalResizingHandler {
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.rightPanelWidth
    }
    
    func setRelevantPanelWidth(panelsDimensions: PanelsDimensions, width: CGFloat) -> PanelsDimensions {
        
        var newPanelsDimensions = panelsDimensions
        newPanelsDimensions.rightPanelWidth = width
        
        return newPanelsDimensions
    }
    
    // MARK: - resizing from resize bars
    func panelResizingLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        return nil
    }
    
    func panelResizingRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let mouseXCoordinateDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let initialPanelWidth = initialPanelsDimensions.rightPanelWidth ?? 0
        return max(0, initialPanelWidth - mouseXCoordinateDifference)
    }
    
    func panelResizingWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let minimumWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        return max(minimumWindowWidth, (initialPanelsDimensions.windowFrame?.width ?? 0) - mouseXCoordinateDifference)
    }
    
    func panelResizingNonElasticXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let maxXCoordinate = (initialPanelsDimensions.windowFrame?.minX ?? 0) + (initialPanelsDimensions.rightPanelWidth ?? 0)
        let nonElasticXCoordinate = min(maxXCoordinate, (initialPanelsDimensions.windowFrame?.minX ?? 0) + mouseXCoordinateDifference)
        
        return nonElasticXCoordinate
    }
    
    func panelResizingMouseToEdgeDifference(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> CGFloat {
        
        let rightEdgeOfFrame = initialPanelsDimensions.windowFrame?.maxX ?? 0
        let mouseXCoordinateToRightEdgeDifference = mouseXCoordinate - rightEdgeOfFrame
        
        return mouseXCoordinateToRightEdgeDifference
    }
    
    func panelResizingElasticXCoordinate(nonElasticCoordinate: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        
        return nonElasticCoordinate + elasticDifference
    }
    
    func panelResizingMouseIsPassedWindowEdge(mouseToEdgeDifference: CGFloat) -> Bool {
        
        return mouseToEdgeDifference < 0
    }
    
    func panelResizingFrameToBounceBackTo(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        let newWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newXCoordinate = (initialPanelsDimensions.windowFrame?.minX ?? 0) + (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newWindowFrame = NSRect(x: newXCoordinate,
                                    y: initialPanelsDimensions.windowFrame?.minY ?? 0,
                                    width: newWindowWidth,
                                    height: initialPanelsDimensions.windowFrame?.height ?? 0)
        
        return self.panelResizingHiddenPanelPanelsDimensions(hidden: true, windowFrame: newWindowFrame, defaultWidth: nil)
    }
    
    // MARK: - auto hide/show
    func panelResizingHiddenPanelPanelsDimensions(hidden: Bool, windowFrame: NSRect, defaultWidth: CGFloat?) -> PanelsDimensions {
        
        let rightPanelWidth = hidden ? 0 : (defaultWidth ?? 0)
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: rightPanelWidth)
    }
    
    func panelResizingHiddenPanelWindowXCoordinate(hidden: Bool, initialPanelDimensions: PanelsDimensions, defaultWidth: CGFloat) -> CGFloat {
        
        if hidden {
            
            let initialRightPanelWidth = (initialPanelDimensions.rightPanelWidth ?? 0)
            return (initialPanelDimensions.windowFrame?.minX ?? 0) + initialRightPanelWidth
        }
        else {
            
            let xCoordinateWithoutPanel = (initialPanelDimensions.windowFrame?.minX ?? 0) + (initialPanelDimensions.rightPanelWidth ?? 0)
            return xCoordinateWithoutPanel - defaultWidth
        }
    }
    
    // MARK: - panel toggling
    func panelTogglingHiddenWindowFrame(panelsDimensions: PanelsDimensions, subtractedWidth: CGFloat) -> NSRect? {
        
        guard var windowFrame = panelsDimensions.windowFrame?.subtractedWidth(subtractedWidth) else {
            return nil
        }
        
        windowFrame = NSRect(x: windowFrame.minX + subtractedWidth, y: windowFrame.minY, width: windowFrame.width, height: windowFrame.height)
        return windowFrame
    }
    
    func panelTogglingShownWindowFrame(panelWidth: CGFloat, panelsDimensions: PanelsDimensions, addedWidth: CGFloat) -> NSRect? {
        
        guard var windowFrame = panelsDimensions.windowFrame?.addedWidth(panelWidth) else {
            return nil
        }
        
        windowFrame = NSRect(x: windowFrame.minX - addedWidth, y: windowFrame.minY, width: windowFrame.width, height: windowFrame.height)
        
        return windowFrame
    }
    
    // MARK: - resizing from window
    func windowResizingElasticXCoordinate(initialPanelsDimensions: PanelsDimensions, elasticDifference: CGFloat, minimumSize: NSSize) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) - elasticDifference
    }
    
    func windowResizingXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0)
    }
}
