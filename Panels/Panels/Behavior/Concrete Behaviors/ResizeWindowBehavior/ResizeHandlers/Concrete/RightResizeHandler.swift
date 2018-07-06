//
//  RightResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class RightResizeHandler: ResizeHandler {
    
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: panel.defaultWidth)
    }
    
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: nil, rightPanelWidth: 0)
    }
    
    func calcRelevantPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return calcRightPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseXCoordinateDifference) ?? 0
    }
    
    func adjustmentToSnapToHiddenWidth(hiddenWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return mouseXCoordinateDifference + hiddenWidthDifference
    }
    
    func adjustmentToSnapToDefaultWidth(defaultWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return mouseXCoordinateDifference + defaultWidthDifference
    }
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        
        return panelsDimensions.rightPanelWidth
    }
    
    func adjustmentToPreventResizingPastWindow(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        if initialPanelWidth - mouseXCoordinateDifference < 0 {
            
            return mouseXCoordinateDifference - (mouseXCoordinateDifference - initialPanelWidth)
        }
        
        return mouseXCoordinateDifference
    }
    
    func calcRightPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat? {
        
        return initialPanelWidth - mouseXCoordinateDifference
    }
    
    func calcLeftPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat? {
        
        return nil
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return initialWindowMinX + mouseXCoordinateDifference
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        
        return initialWindowMinX + widthToSubtract
    }
    
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        
        return initialWindowMinX - widthToAdd
    }
    
    func calcWindowWidth(initialWindowWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        
        return initialWindowWidth - mouseXCoordinateDifference
    }
}
