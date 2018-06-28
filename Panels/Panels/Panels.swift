//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView {
    
    @IBOutlet weak var leftPanel: NSView!
    @IBOutlet weak var mainPanel: NSView!
    @IBOutlet weak var rightPanel: NSView!
    
    // view controllers of each view
    private var leftViewContrller: NSViewController? = nil
    private var mainViewController: NSViewController? = nil
    private var rightViewContrller: NSViewController? = nil
    
    public static func sweetHomeAlabama(leftPanel: NSViewController?, mainPanel: NSViewController?, rightPanel: NSViewController?) -> Panels? {
        
        var topLevelObjects: NSArray? = NSArray()

        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: "Panels"), owner: self, topLevelObjects: &topLevelObjects)
        
        guard let panels = topLevelObjects?.first(where: { (object) -> Bool in
            object is Panels
        }) as? Panels else {
            print("WTF")
            return nil
        }
        
        panels.leftViewContrller = leftPanel
        panels.mainViewController = mainPanel
        panels.rightViewContrller = rightPanel
        
        
        if let leftView = leftPanel?.view {
            panels.leftPanel.addSubview(leftView)
        }
        if let mainView = mainPanel?.view {
            panels.mainPanel.addSubview(mainView)
        }
        if let rightView = rightPanel?.view {
            panels.rightPanel.addSubview(rightView)
        }
        
        return panels
    }
    
//    public override init(frame frameRect: NSRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
//    
//    required public init?(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//        self.commonInit()
//    }
}
