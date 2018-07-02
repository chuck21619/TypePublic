//
//  PanelInterface.swift
//  Panels
//
//  Created by charles johnston on 6/30/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public protocol PanelInterface {
    
    // contructors
    init(position: PanelPosition, minimumWidth: CGFloat, viewController: NSViewController?)
    
    // properties
    var position: PanelPosition { get }
    var minimumWidth: CGFloat { get set }
    var viewController: NSViewController? { get set }
    
    // methods
//    func showPanel(_ show: Bool, animated: Bool)
}
