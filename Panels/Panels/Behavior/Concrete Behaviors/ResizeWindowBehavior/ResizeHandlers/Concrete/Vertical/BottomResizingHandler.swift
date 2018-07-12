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
        
        return (initialPanelsDimensions.windowFrame?.minY ?? 0) + elasticDifference
    }
    
    func calcHeightDifference(initialPanelsDimensions: PanelsDimensions, minimumSize: NSSize) -> CGFloat {
        
        return 0
        //        return (initialPanelsDimensions.windowFrame?.width ?? 0) - minimumSize.width
    }
}
