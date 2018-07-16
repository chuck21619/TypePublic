//
//  ResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol HorizontalResizingHandler {
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat?
    
    // resizing from resize bars
    func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    
    func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions?
    
    // auto hide/show
    func calcPanelsDimensions(hidden: Bool, windowFrame: NSRect, defaultWidth: CGFloat?) -> PanelsDimensions
    func calcWindowXCoordinate(hidden: Bool, initialPanelDimensions: PanelsDimensions, defaultWidth: CGFloat) -> CGFloat
    
    // resizing from window
    func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat
    func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat
}
