//
//  ResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class HorizontalResizingHandler {
    
    // resizing from resize bars
    func calcWindowFrame(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> NSRect {
        
        let mouseLocationDifference = currentMouseXCoordinate - initialMouseXCoordinate
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = self.calcWindowWidth(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = self.calcWindowXCoordinate(initialPanelsDimensions: initialPanelsDimensions, mouseXCoordinate: currentMouseXCoordinate, mouseXCoordinateDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        return newFrame
    }
    
    func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        fatalError("must be overridden in subclass")
        
    }
    func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat? {
        fatalError("must be overridden in subclass")
        
    }
    
    func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions? {
        fatalError("must be overridden in subclass")
        
    }
    
    // auto hide/show
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat? {
        fatalError("must be overridden in subclass")
        
    }
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions {
        fatalError("must be overridden in subclass")
        
    }
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions {
        fatalError("must be overridden in subclass")
        
    }
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    
    // resizing from window
    func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
    func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        fatalError("must be overridden in subclass")
        
    }
}
