//
//  PanelsDelegate.swift
//  Panels
//
//  Created by charles johnston on 2/11/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation

public protocol PanelsDelegate {
    
    func didStartResizing(panelPosition: PanelPosition)
    func didEndResizing(panelPosition: PanelPosition, hidingPanel: Bool)
}
