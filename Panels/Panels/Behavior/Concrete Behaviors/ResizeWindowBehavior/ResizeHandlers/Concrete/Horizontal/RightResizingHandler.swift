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
    
    // MARK: - resizing from resize bars
    func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let mouseXCoordinateDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let initialPanelWidth = initialPanelsDimensions.rightPanelWidth ?? 0
        return max(0, initialPanelWidth - mouseXCoordinateDifference)
    }
    
    func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let minimumWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        return max(minimumWindowWidth, (initialPanelsDimensions.windowFrame?.width ?? 0) - mouseXCoordinateDifference)
    }
    
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let maxXCoordinate = (initialPanelsDimensions.windowFrame?.minX ?? 0) + (initialPanelsDimensions.rightPanelWidth ?? 0)
        
        let rightEdgeOfFrame = initialPanelsDimensions.windowFrame?.maxX ?? 0
        let mouseXCoordinateToRightEdgeDifference = mouseXCoordinate - rightEdgeOfFrame
        
        let nonElasticXCoordinate = min(maxXCoordinate, (initialPanelsDimensions.windowFrame?.minX ?? 0) + mouseXCoordinateDifference)
        if mouseXCoordinateToRightEdgeDifference < 0 {
            return nonElasticXCoordinate
        }
        
        let elasticDifference = pow(mouseXCoordinateToRightEdgeDifference, 0.7)
        let elasticXCoordinate = nonElasticXCoordinate + elasticDifference
        
        return elasticXCoordinate
    }
    
    func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        let newWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newXCoordinate = (initialPanelsDimensions.windowFrame?.minX ?? 0) + (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newWindowFrame = NSRect(x: newXCoordinate,
                                    y: initialPanelsDimensions.windowFrame?.minY ?? 0,
                                    width: newWindowWidth,
                                    height: initialPanelsDimensions.windowFrame?.height ?? 0)
        
        return self.calcPanelsDimensions(hidden: true, windowFrame: newWindowFrame, defaultWidth: nil)
    }
    
    // MARK: - auto hide/show
    func calcPanelsDimensions(hidden: Bool, windowFrame: NSRect, defaultWidth: CGFloat?) -> PanelsDimensions {
        
        let rightPanelWidth = hidden ? 0 : (defaultWidth ?? 0)
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: rightPanelWidth)
    }
    
    func calcWindowXCoordinate(hidden: Bool, initialPanelDimensions: PanelsDimensions, defaultWidth: CGFloat) -> CGFloat {
        
        if hidden {
            
            let initialRightPanelWidth = (initialPanelDimensions.rightPanelWidth ?? 0)
            return (initialPanelDimensions.windowFrame?.minX ?? 0) + initialRightPanelWidth
        }
        else {
            
            let xCoordinateWithoutPanel = (initialPanelDimensions.windowFrame?.minX ?? 0) + (initialPanelDimensions.rightPanelWidth ?? 0)
            return xCoordinateWithoutPanel - defaultWidth
        }
    }
    
    // MARK: - resizing from window
    func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        
        return 0
    }
    
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) - elasticDifference
    }
    
    func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0)
    }
}
