//
//  LeftResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class LeftResizingHandler: HorizontalResizingHandler {
    
    // resizing from resize bars
    override func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    override func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let mouseXCoordinateDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let initialPanelWidth = initialPanelsDimensions.leftPanelWidth ?? 0
        return max(0, initialPanelWidth + mouseXCoordinateDifference)
    }
    
    override func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        let newWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.leftPanelWidth ?? 0)
        let newWindowFrame = NSRect(x: initialPanelsDimensions.windowFrame?.minX ?? 0,
                                    y: initialPanelsDimensions.windowFrame?.minY ?? 0,
                                    width: newWindowWidth,
                                    height: initialPanelsDimensions.windowFrame?.height ?? 0)
        return self.calcHiddenPanelPanelsDimensions(windowFrame: newWindowFrame)
    }
    
    override func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: panel.defaultWidth, rightPanelWidth: nil)
    }
    
    override func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: 0, rightPanelWidth: nil)
    }
    
    override func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.leftPanelWidth
    }
    
    override func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let nonElasticXCoordinate = initialPanelsDimensions.windowFrame?.minX ?? 0
        
        let mouseXCoordinateToLeftEdgeDifference = mouseXCoordinate - nonElasticXCoordinate
        
        if mouseXCoordinateToLeftEdgeDifference > 0 {
            return nonElasticXCoordinate
        }

        let elasticDifference = pow(abs(mouseXCoordinateToLeftEdgeDifference), 0.7)
        let elasticXCoordinate = nonElasticXCoordinate - elasticDifference

        return elasticXCoordinate
    }
    
    override func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let minimumWindowWidth = max(0, (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.leftPanelWidth ?? 0))
        return max(minimumWindowWidth, (initialPanelsDimensions.windowFrame?.width ?? 0) + mouseXCoordinateDifference)
    }
    
    // auto hide/show
    override func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    override func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    // resizing from window
    override func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.width ?? 0) - minimumSize.width
    }
    
    override func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference + elasticDifference
    }
    
    override func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        let widthDifference = (initialPanelsDimensions.windowFrame?.width ?? 0) - (currentPanelsDimensions.windowFrame?.width ?? 0)
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference
    }
}
