//
//  VerticalResizingHandler.swift
//  Panels
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol VerticalResizingHandler {
    
    func calcWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, minimumSize: NSSize) -> CGFloat
    
    //elastic
    func clacWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat
//    func calcHeightDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat
}
