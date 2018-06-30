//
//  Panel.swift
//  Panels
//
//  Created by charles johnston on 6/30/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public enum PanelPosition: String {
    case left
    case main
    case right
}

public class Panel: PanelInterface {
    
    public let position: PanelPosition
    public var viewController: NSViewController?
    
    public required init(position: PanelPosition, viewController: NSViewController?) {
        
        self.position = position
        self.viewController = viewController
    }
}
