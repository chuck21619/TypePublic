//
//  Axis.swift
//  Panels
//
//  Created by charles johnston on 7/17/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol Axis {
    
    func size(size: NSSize) -> CGFloat
    func origin(rect: NSRect) -> CGFloat
    func containsOriginSide(sides: [Side]) -> Bool
    
    func elasticOrigin(resizingSides: [Side], initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, mininumSize: NSSize) -> CGFloat
}
