//
//  PanelsInterface.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public protocol PanelsInterface {
    
    func set(panels: [Panel])
    
//    func setPanels(leftPanel leftViewController: NSViewController?, mainPanel mainViewController: NSViewController?, rightPanel rightViewController: NSViewController?)
    
    
    //set autoHide threshholds //maybe a percentage of screen space or a flat number
    //get and set which panels are visible
    //var independantFullScreenState //each panel has an open/close state for fullscreen as well as non-fullscreen
    //set width
}
