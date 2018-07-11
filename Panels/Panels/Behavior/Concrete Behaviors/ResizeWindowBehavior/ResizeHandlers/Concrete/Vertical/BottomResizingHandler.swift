//
//  BottomResizingHandler.swift
//  Panels
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class BottomResizingHandler: VerticalResizingHandler {
    
    func calcWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize) -> CGFloat {
        
        let yToSubtract = newFrameSize.height - (initialPanelsDimensions.windowFrame?.height ?? 0)
        return (initialPanelsDimensions.windowFrame?.minY ?? 0) - yToSubtract
    }
}
