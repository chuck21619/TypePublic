//
//  RightResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class RightResizingHandler: HorizontalResizingHandler {
    
    override func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    override func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let mouseXCoordinateDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let initialPanelWidth = initialPanelsDimensions.rightPanelWidth ?? 0
        return max(0, initialPanelWidth - mouseXCoordinateDifference)
    }
    
    override func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        let newWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newXCoordinate = (initialPanelsDimensions.windowFrame?.minX ?? 0) + (initialPanelsDimensions.rightPanelWidth ?? 0)
        let newWindowFrame = NSRect(x: newXCoordinate,
                                    y: initialPanelsDimensions.windowFrame?.minY ?? 0,
                                    width: newWindowWidth,
                                    height: initialPanelsDimensions.windowFrame?.height ?? 0)
        return self.calcHiddenPanelPanelsDimensions(windowFrame: newWindowFrame)
    }
    
    override func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: panel.defaultWidth)
    }
    
    override func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: 0)
    }
    
    override func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.rightPanelWidth
    }
    
    override func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let minimumWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.rightPanelWidth ?? 0)
        return max(minimumWindowWidth, (initialPanelsDimensions.windowFrame?.width ?? 0) - mouseXCoordinateDifference)
    }
    
    override func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
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
    
    // auto hide/show
    override func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        
        return initialWindowMinX + widthToSubtract
    }
    
    override func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        
        return initialWindowMinX - widthToAdd
    }
    
    // resizing from window
    override func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        
        return 0
    }
    
    override func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) - elasticDifference
    }
    
    override func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0)
    }
}
