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
    func setRelevantPanelWidth(panelsDimensions: PanelsDimensions, width: CGFloat) -> PanelsDimensions
    
    // panel resizing
    func panelResizingLeftPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    func panelResizingRightPanelWidth(initialPanelsDimensions: PanelsDimensions, initialMouseXCoordinate: CGFloat, currentMouseXCoordinate: CGFloat) -> CGFloat?
    func panelResizingWindowWidth(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func panelResizingNonElasticXCoordinate(initialPanelsDimensions: PanelsDimensions, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func panelResizingMouseToEdgeDifference(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> CGFloat
    func panelResizingElasticXCoordinate(nonElasticCoordinate: CGFloat, elasticDifference: CGFloat) -> CGFloat
    func panelResizingMouseIsPassedWindowEdge(mouseToEdgeDifference: CGFloat) -> Bool
    func panelResizingFrameToBounceBackTo(initialPanelsDimensions: PanelsDimensions, mouseXCoordinate: CGFloat) -> PanelsDimensions?
    func panelResizingHiddenPanelPanelsDimensions(hidden: Bool, windowFrame: NSRect, defaultWidth: CGFloat?) -> PanelsDimensions
    func panelResizingHiddenPanelWindowXCoordinate(hidden: Bool, initialPanelDimensions: PanelsDimensions, defaultWidth: CGFloat) -> CGFloat
    
    // window resizing
    func windowResizingElasticXCoordinate(initialPanelsDimensions: PanelsDimensions, elasticDifference: CGFloat, minimumSize: NSSize) -> CGFloat
    func windowResizingXCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat
}
