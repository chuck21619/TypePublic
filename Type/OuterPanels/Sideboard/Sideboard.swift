//
//  Sideboard.swift
//  Type
//
//  Created by charles johnston on 2/4/19.
//  Copyright © 2019 ZinStudio. All rights reserved.
//

import Foundation
import AppKit

class SideboardViewController: NSViewController {
    
    @IBOutlet weak var scrollview: NSScrollView!
    @IBAction func buttonAction(_ sender: Any) {
        
        self.scrollview.hasVerticalScroller = !self.scrollview.hasVerticalScroller
    }
}