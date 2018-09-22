//
//  TopResizingHandler.swift
//  Panels
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class TopResizingHandler: VerticalResizingHandler {
    
    func calcWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, minimumSize: NSSize) -> CGFloat {
        
        return ((initialPanelsDimensions.windowFrame?.minY ?? 0) - elasticDifference)
    }
    
    func clacWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        return (initialPanelsDimensions.windowFrame?.minY ?? 0)
    }
}
