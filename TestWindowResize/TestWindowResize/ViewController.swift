//
//  ViewController.swift
//  TestWindowResize
//
//  Created by charles johnston on 6/29/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackingArea = NSTrackingArea(rect: self.view.frame, options: [.activeInKeyWindow, .mouseMoved], owner: nil, userInfo: nil)
        self.view.addTrackingArea(trackingArea)
        
    }
    
    override func mouseMoved(with event: NSEvent) {
        print(event)
    }

}

