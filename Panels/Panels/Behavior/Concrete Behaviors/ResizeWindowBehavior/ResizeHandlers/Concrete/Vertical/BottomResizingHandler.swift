//
//  BottomResizingHandler.swift
//  Panels
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class BottomResizingHandler: VerticalResizingHandler {
    
    func calcWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize, elasticDifference: CGFloat, minimumSize: NSSize) -> CGFloat {
        
        let heightDifference = (initialPanelsDimensions.windowFrame?.height ?? 0) - minimumSize.height
        return (initialPanelsDimensions.windowFrame?.minY ?? 0) + heightDifference + elasticDifference
    }
    
    func clacWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, currentPanelsDimensions: PanelsDimensions) -> CGFloat {
        
        let heightDifference = (initialPanelsDimensions.windowFrame?.height ?? 0) - (currentPanelsDimensions.windowFrame?.height ?? 0)
        return (initialPanelsDimensions.windowFrame?.minY ?? 0) + heightDifference
    }
}
