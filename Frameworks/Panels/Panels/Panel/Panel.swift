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
    public var minimumHeight: CGFloat
    
    public init(position: PanelPosition, viewController: NSViewController?, hidingThreshold: CGFloat = 100, defaultWidth: CGFloat = 240, minimumHeight: CGFloat = 600) {
        
        self.position = position
        self.viewController = viewController
        self.hidingThreshold = hidingThreshold
        self.defaultWidth = defaultWidth
        self.minimumHeight = minimumHeight
    }
}

