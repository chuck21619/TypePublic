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
    func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        
        let mouseXCoordinateDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let initialPanelWidth = initialPanelsDimensions.leftPanelWidth ?? 0
        return max(0, initialPanelWidth + mouseXCoordinateDifference)
    }
    
    func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        
        let newWindowWidth = (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.leftPanelWidth ?? 0)
        let newWindowFrame = NSRect(x: initialPanelsDimensions.windowFrame?.minX ?? 0,
                                    y: initialPanelsDimensions.windowFrame?.minY ?? 0,
                                    width: newWindowWidth,
                                    height: initialPanelsDimensions.windowFrame?.height ?? 0)
        return self.calcHiddenPanelPanelsDimensions(windowFrame: newWindowFrame)
    }
    
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: panel.defaultWidth, rightPanelWidth: nil)
    }
    
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: 0, rightPanelWidth: nil)
    }
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.leftPanelWidth
    }
    
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let nonElasticXCoordinate = initialPanelsDimensions.windowFrame?.minX ?? 0
        
        let mouseXCoordinateToLeftEdgeDifference = mouseXCoordinate - nonElasticXCoordinate
        
        if mouseXCoordinateToLeftEdgeDifference > 0 {
            return nonElasticXCoordinate
        }

        let elasticDifference = pow(abs(mouseXCoordinateToLeftEdgeDifference), 0.7)
        let elasticXCoordinate = nonElasticXCoordinate - elasticDifference

        return elasticXCoordinate
    }
    
    func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        let minimumWindowWidth = max(0, (initialPanelsDimensions.windowFrame?.width ?? 0) - (initialPanelsDimensions.leftPanelWidth ?? 0))
        return max(minimumWindowWidth, (initialPanelsDimensions.windowFrame?.width ?? 0) + mouseXCoordinateDifference)
    }
    
    // auto hide/show
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    // resizing from window
    func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.width ?? 0) - minimumSize.width
    }
    
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference + elasticDifference
    }
    
    func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        let widthDifference = (initialPanelsDimensions.windowFrame?.width ?? 0) - (currentPanelsDimensions.windowFrame?.width ?? 0)
        return (initialPanelsDimensions.windowFrame?.minX ?? 0) + widthDifference
    }
}
