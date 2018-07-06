//
//  ResizeHandler.swift
//  Panels
//
//  Created by charles johnston on 7/6/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol ResizeHandler {
    
    func relevantPanelWidth(panelsDimensions: PanelsDimensions) -> CGFloat?
    
    func calcWindowWidth(initialWindowWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToSubtract: CGFloat) -> CGFloat
    func calcWindowXCoordinate(initialWindowMinX: CGFloat, widthToAdd: CGFloat) -> CGFloat
    func calcRelevantPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func calcRightPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat?
    func calcLeftPanelWidth(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat?
    func calcHiddenPanelPanelsDimensions(windowFrame: NSRect) -> PanelsDimensions
    func calcDefaultPanelPanelsDimensions(windowFrame: NSRect, panel: Panel) -> PanelsDimensions
    
    func adjustmentToPreventResizingPastWindow(initialPanelWidth: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func adjustmentToSnapToDefaultWidth(defaultWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
    func adjustmentToSnapToHiddenWidth(hiddenWidthDifference: CGFloat, mouseXCoordinateDifference: CGFloat) -> CGFloat
}
