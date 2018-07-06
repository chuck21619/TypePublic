//
//  LeftResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class LeftResizeHandler: ResizeHandler {
    
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: panel.defaultWidth, rightPanelWidth: nil)
    }
    
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: 0, rightPanelWidth: nil)
    }
    
    func calcRelevantPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return calcLeftPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseXCoordinateDifference) ?? 0
    }
    
    func adjustmentToSnapToHiddenWidth(hiddenWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return mouseXCoordinateDifference - hiddenWidthDifference
    }
    
    func adjustmentToSnapToDefaultWidth(defaultWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return mouseXCoordinateDifference - defaultWidthDifference
    }
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.leftPanelWidth
    }
    
    func adjustmentToPreventResizingPastWindow(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        if initialPanelWidth + mouseXCoordinateDifference < 0 {
            
            return -initialPanelWidth
        }
        
        return mouseXCoordinateDifference
    }
    
    func calcRightPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    func calcLeftPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat? {
        
        return initialPanelWidth + mouseXCoordinateDifference
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        
        return initialWindowMinX
    }
    
    func calcWindowWidth(initialWindowWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return initialWindowWidth + mouseXCoordinateDifference
    }
}
