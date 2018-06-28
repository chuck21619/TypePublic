//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView, PanelsInterface {
    
    // MARK: - public interface
    public func setLeftPanel(_ leftViewController: NSViewController?) {
        
        self.leftViewController = leftViewController
    }
    
    public func setMainPanel(_ mainViewController: NSViewController?) {
        
        self.mainViewController = mainViewController
    }
    
    public func setRightPanel(_ rightViewController: NSViewController?) {
        
        self.rightViewController = rightViewController
    }
    
    public func setPanels(leftPanel leftViewController: NSViewController?, mainPanel mainViewController: NSViewController?, rightPanel rightViewController: NSViewController?) {
        
        self.leftViewController = leftViewController
        self.mainViewController = mainViewController
        self.rightViewController = rightViewController
    }
    
    // MARK: - properties
    @IBOutlet var contentView: Panels!
    
    @IBOutlet weak var leftPanel: NSView!
    @IBOutlet weak var mainPanel: NSView!
    @IBOutlet weak var rightPanel: NSView!
    
    // view controllers of each view
    private var leftViewController: NSViewController? = nil {
        
        didSet {
            for view in leftPanel.subviews {
                view.removeFromSuperview()
            }
            
            if let view = leftViewController?.view {
                
                leftPanel.addSubview(view)
            }
        }
    }
    private var mainViewController: NSViewController? = nil {
        
        didSet {
            for view in mainPanel.subviews {
                view.removeFromSuperview()
            }
            
            if let view = mainViewController?.view {
                
                mainPanel.addSubview(view)
            }
        }
    }
    private var rightViewController: NSViewController? = nil {
        
        didSet {
            for view in rightPanel.subviews {
                view.removeFromSuperview()
            }
            
            if let view = rightViewController?.view {
                
                rightPanel.addSubview(view)
            }
        }
    }
    
    // MARK: - Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: "Panels"), owner: self, topLevelObjects: &topLevelObjects)
        addSubview(contentView)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
}
