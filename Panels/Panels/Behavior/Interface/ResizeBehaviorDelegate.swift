//
//  ResizeBehaviorDelegate.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol ResizeBehaviorDelegate {
    
    func didUpdate(panelsDimensions: PanelsDimensions, animated: Bool)
    func currentPanelsDimensions() -> PanelsDimensions
    func setAutomaticResizing(_ enabled: Bool)
}
