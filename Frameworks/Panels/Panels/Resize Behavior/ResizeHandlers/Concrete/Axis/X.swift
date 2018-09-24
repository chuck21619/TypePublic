//
//  X.swift
//  Panels
//
//  Created by charles johnston on 7/17/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class X: Axis {
    
    func origin(rect: NSRect) -> CGFloat {
        return rect.minX
    }
    
    func size(size: NSSize) -> CGFloat {
        return size.width
    }
    
    func containsOriginSide(sides: [Side]) -> Bool {
        return sides.contains(.left)
    }
    
    func elasticOrigin(resizingSides: [Side], initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, mininumSize: NSSize) -> CGFloat {
        
        let horizontalResizingHandler: HorizontalResizingHandler = resizingSides.contains(.left) ? LeftResizingHandler() : RightResizingHandler()
        let newAxisOrigin = horizontalResizingHandler.windowResizingElasticXCoordinate(initialPanelsDimensions: initialPanelsDimensions, elasticDifference: elasticDifference, minimumSize: mininumSize)
        
        return newAxisOrigin
    }
}
