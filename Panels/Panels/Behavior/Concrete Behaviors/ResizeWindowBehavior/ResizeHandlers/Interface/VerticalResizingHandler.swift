//
//  VerticalResizingHandler.swift
//  Panels
//
//  Created by charles johnston on 7/10/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol VerticalResizingHandler {
    
    func calcWindowYCoordinate(initialPanelsDimensions: PanelsDimensions, newFrameSize: NSSize) -> CGFloat
}
