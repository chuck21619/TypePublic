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

        
        let someView = NSView(frame: NSRect(x: 50, y: 50, width: 50, height: 50))
        self.view.addSubview(someView)
        someView.layer?.borderWidth = 1
        someView.layer?.backgroundColor = .black
        
        
        let someLable = NSTextField(frame: NSRect(x: 100, y: 100, width: 100, height: 100))
        someLable.stringValue = "awef"
        self.view.addSubview(someLable)
        someView
        
//        someView.needsLayout = true
//        someView.needsDisplay = true
//        self.view.needsLayout = true
//        self.view.needsDisplay = true
//        self.view.displayIfNeeded()
        // Do any additional setup after loading the view.
    }

}

