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
    
    static func create(with viewController: NSViewController) -> SideboardViewController? {
        
        
        let sideboardStoryboard = NSStoryboard(name: "Sideboard", bundle: Bundle.main)
        let sideboardFromStoryboard = sideboardStoryboard.instantiateInitialController() as? SideboardViewController
        
        guard let sideboard = sideboardFromStoryboard else {
            return nil
        }
        
//        sideboard.loadView()
        
        let view = viewController.view
        
        for view in sideboard.view.subviews {
            view.removeFromSuperview()
        }
        
        view.frame = sideboard.view.bounds
        view.autoresizingMask = [.width, .height]
        sideboard.view.addSubview(view)
        
        
        return sideboard
    }
    
    // MARK: - Properties
    @IBOutlet weak var scrollview: NSScrollView!
    
    // MARK: - Methods
    //test
    @IBAction func buttonAction(_ sender: Any) {
        
        self.scrollview.hasVerticalScroller = !self.scrollview.hasVerticalScroller
    }
    
    func setScrollbarHidden(_ hidden: Bool) {
        
        self.scrollview.hasVerticalScroller = !hidden
    }
    
    
//    //initialization
//    override func viewDidLoad() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didLiveScroll), name: NSScrollView.didLiveScrollNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(willStartLiveScroll), name: NSScrollView.willStartLiveScrollNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(didEndLiveScroll), name: NSScrollView.didEndLiveScrollNotification, object: nil)
//    }
//
//    //scrollview notifications in order to hide scrollbar when not scrolling
//    var testInt = 0
//    @objc func didLiveScroll() {
//
//        testInt += 1
//        print("didLiveScroll: \(testInt)")
//    }
//
//    var testInt1 = 0
//    @objc func willStartLiveScroll() {
//
//        testInt1 += 1
//        print("willStartLiveScroll: \(testInt1)")
//    }
//
//    var testInt2 = 0
//    @objc func didEndLiveScroll() {
//
//        testInt2 += 1
//        print("didEndLiveScroll: \(testInt2)")
//    }
}
