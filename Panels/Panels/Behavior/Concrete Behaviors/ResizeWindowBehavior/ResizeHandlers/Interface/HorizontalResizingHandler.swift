//
//  ResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol HorizontalResizingHandler {
    
    // resizing from resize bars
    func calcLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    func calcRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    
    func calcWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcElasticEndFrame(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions?
    
    // auto hide/show
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat?
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat
    
    // resizing from window
    func calcWidthDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat
    func calcWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, widthDifference: CGFloat, elasticDifference: CGFloat) -> CGFloat
    func clacWindowXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat
}
