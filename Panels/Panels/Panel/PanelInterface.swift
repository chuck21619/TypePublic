//
//  PanelInterface.swift
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

public protocol PanelInterface {
    
    // contructors
    init(position: PanelPosition, viewController: NSViewController?)
    
    // properties
    var position: PanelPosition { get }
    var viewController: NSViewController? { get set }
    
    // methods
    func minimumSize() -> NSSize
//    func showPanel(_ show: Bool, animated: Bool)
}
