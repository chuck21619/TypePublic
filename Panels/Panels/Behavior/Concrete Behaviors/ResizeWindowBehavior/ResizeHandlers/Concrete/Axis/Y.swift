//
//  Y.swift
//  Panels
//
//  Created by charles johnston on 7/17/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class Y: Axis {
    
    func origin(rect: NSRect) -> CGFloat {
        return rect.minY
    }
    
    func size(size: NSSize) -> CGFloat {
        return size.height
    }
    
    func containsOriginSide(sides: [Side]) -> Bool {
        return sides.contains(.bottom)
    }
    
    func elasticOrigin(resizingSides: [Side], initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, mininumSize: NSSize) -> CGFloat {
        
        let verticalResizingHandler: VerticalResizingHandler = resizingSides.contains(.top) ? TopResizingHandler() : BottomResizingHandler()
        let newAxisOrigin = verticalResizingHandler.calcWindowYCoordinate(initialPanelsDimensions: initialPanelsDimensions, newFrameSize: newFrameSize, elasticDifference: elasticDifference, minimumSize: mininumSize)
        
        return newAxisOrigin
    }
}
