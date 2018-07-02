//
//  Panel.swift
//  Panels
//
//  Created by charles johnston on 6/30/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panel: PanelInterface {
    
    public let position: PanelPosition
    public var viewController: NSViewController?
    
    var resizeable: Bool = true
    
    public required init(position: PanelPosition, viewController: NSViewController?) {
        
        self.position = position
        self.viewController = viewController
    }
 
    public func minimumSize() -> NSSize {
        
        return self.viewController?.view.fittingSize ?? .zero
    }
}

