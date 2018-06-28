//
//  PanelsInterface.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol PanelsInterface {
    
    func setLeftPanel(_ leftViewController: NSViewController?)
    
    func setMainPanel(_ mainViewController: NSViewController?)
    
    func setRightPanel(_ rightViewController: NSViewController?)
    
    func setPanels(leftPanel leftViewController: NSViewController?, mainPanel mainViewController: NSViewController?, rightPanel rightViewController: NSViewController?)
    
    
    //setAutoHideThreshHolds()
    //toggleShowPanel(.left, .right, .main)
    //visiblePanels() -> (bool, bool, bool)
}
