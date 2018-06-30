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
    // outlets
    @IBOutlet var contentView: NSView!
    
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
//                view.wantsLayer = true
//                view.layer?.borderWidth = 1
                
//                view.leadingAnchor.constraint(equalTo: leftPanel.leadingAnchor)
//                view.trailingAnchor.constraint(equalTo: leftPanel.trailingAnchor)
//                view.topAnchor.constraint(equalTo: leftPanel.topAnchor)
//                view.bottomAnchor.constraint(equalTo: leftPanel.bottomAnchor)
////
//                view.autoresizingMask = [.width, .height]
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
                
                
//                view.wantsLayer = true
//                view.layer?.borderWidth = 1
//
//                view.leadingAnchor.constraint(equalTo: mainPanel.leadingAnchor)
//                view.trailingAnchor.constraint(equalTo: mainPanel.trailingAnchor)
//                view.topAnchor.constraint(equalTo: mainPanel.topAnchor)
//                view.bottomAnchor.constraint(equalTo: mainPanel.bottomAnchor)
//
//                view.autoresizingMask = [.width, .height]
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
//                view.wantsLayer = true
//                view.layer?.borderWidth = 1
//                view.leadingAnchor.constraint(equalTo: rightPanel.leadingAnchor)
//                view.trailingAnchor.constraint(equalTo: rightPanel.trailingAnchor)
//                view.topAnchor.constraint(equalTo: rightPanel.topAnchor)
//                view.bottomAnchor.constraint(equalTo: rightPanel.bottomAnchor)
//
//                view.autoresizingMask = [.width, .height]
                rightPanel.addSubview(view)
            }
        }
    }
    
    // MARK: - Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: String(describing: Panels.self)), owner: self, topLevelObjects: &topLevelObjects)
        
        contentView.frame = self.bounds
//        self.autoresizingMask = [.width, .height]
        addSubview(contentView)
        
        contentView.wantsLayer = true
        contentView.layer?.borderWidth = 1
        contentView.layer?.borderColor = CGColor(red: 1, green: 0, blue: 1, alpha: 1)
        
        
//        self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        self.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        leftPanel.wantsLayer = true
        leftPanel.layer?.borderWidth = 2
        leftPanel.layer?.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        mainPanel.wantsLayer = true
        mainPanel.layer?.borderWidth = 2
        mainPanel.layer?.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        rightPanel.wantsLayer = true
        rightPanel.layer?.borderWidth = 2
        rightPanel.layer?.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        
//        leftPanel.autoresizingMask = [.width, .height]
//        mainPanel.autoresizingMask = [.width, .height]
//        rightPanel.autoresizingMask = [.width, .height]
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
