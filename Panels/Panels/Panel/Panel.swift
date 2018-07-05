//
//  Panel.swift
//  Panels
//
//  Created by charles johnston on 6/30/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public struct Panel {
    
    public let position: PanelPosition
    public var viewController: NSViewController?
    public var hidingThreshold: CGFloat
    public var defaultWidth: CGFloat
    
    public init(position: PanelPosition, viewController: NSViewController?, hidingThreshold: CGFloat = 65, defaultWidth: CGFloat = 200) {
        
        self.position = position
        self.viewController = viewController
        self.hidingThreshold = hidingThreshold
        self.defaultWidth = defaultWidth
    }
}

