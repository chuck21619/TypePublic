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
    public func set(panels: [Panel]) {
        
        //left panel
        if let leftPanel = panels.first(where: { (panel) -> Bool in
            panel.position == .left
        }) {
            self.leftPanel = leftPanel
        }
        
        //main panel
        if let mainPanel = panels.first(where: { (panel) -> Bool in
            panel.position == .main
        }) {
            self.mainPanel = mainPanel
        }
        
        //right panel
        if let rightPanel = panels.first(where: { (panel) -> Bool in
            panel.position == .right
        }) {
            self.rightPanel = rightPanel
        }
    }
    
    public var leftPanel: Panel? {
        
        didSet {
            
            replace(contentsOf: leftPanelView, with: leftPanel?.viewController?.view)
        }
    }
    
    public var mainPanel: Panel? {
        
        didSet {
            
            replace(contentsOf: mainPanelView, with: mainPanel?.viewController?.view)
        }
    }
    
    public var rightPanel: Panel? {
        
        didSet {
            
            replace(contentsOf: rightPanelView, with: rightPanel?.viewController?.view)
        }
    }
    
    
    // MARK: - implementation
    // MARK: - properties
    // outlets
    @IBOutlet weak var leftPanelViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPanelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: NSView!
    
    @IBOutlet weak var leftPanelView: NSView!
    @IBOutlet weak var mainPanelView: NSView!
    @IBOutlet weak var rightPanelView: NSView!
    
    @IBOutlet weak var resizeBarLeft: ResizeBar!
    @IBOutlet weak var resizeBarRight: ResizeBar!
    
    // MARK: - Methods
    // MARK: Resizing gestures
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        if sender.state == .began {
            NSCursor.hide()
        }
        else if sender.state == .ended {
            NSCursor.unhide()
        }
        
        let xCoordinate = sender.location(in: contentView).x
        
        // cannot resize to the left of the window
        guard xCoordinate > 0 else {
            return
        }
        
        // do not resize to the left of leftPanels minimumWidth
        if let leftPanel = leftPanel {
            
            guard xCoordinate > leftPanel.minimumSize().width else {
                
                return
            }
        }
        
        // do not resize to the right of mainPanels minimumWidth
        if let mainPanel = mainPanel {
            
            guard xCoordinate < mainPanelView.frame.maxX - mainPanel.minimumSize().width else {
                
                return
            }
        }
        
        // do not allow resizing to the right of the main panel
        guard xCoordinate < leftPanelView.frame.width + mainPanelView.frame.width else {
            return
        }
        
        leftPanelViewWidthConstraint.constant = sender.location(in: contentView).x
    }
    
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        if sender.state == .began {
            NSCursor.hide()
        }
        else if sender.state == .ended {
            NSCursor.unhide()
        }
        
        let xCoordinate = sender.location(in: contentView).x
        
        // cannot resize to the right of the window
        guard xCoordinate < contentView.frame.width else {
            return
        }
        
        // do not allow resizing to the left of the main panel
        guard xCoordinate > leftPanelView.frame.width else {
            return
        }
        
        // do not allow resizing to the left of the main panel's minimum width
        guard xCoordinate > leftPanelView.frame.width + (mainPanel?.minimumSize().width ?? 0) else {
            return
        }
        
        // do not allow resizing to the right of rightPanel's minimum width
        guard xCoordinate < contentView.frame.width - (rightPanel?.minimumSize().width ?? 0) else {
            return
        }
        
        rightPanelWidthConstraint.constant = contentView.frame.width - sender.location(in: contentView).x
        
    }
    
    // helper method
    private func replace(contentsOf view: NSView, with newView: NSView?) {
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        if let newView = newView {
            newView.frame = view.bounds
            newView.autoresizingMask = [.width, .height]
            view.addSubview(newView)
        }
    }
    
    // MARK: Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: String(describing: Panels.self)), owner: self, topLevelObjects: &topLevelObjects)
        
        contentView.frame = self.bounds
        addSubview(contentView)
        
        // debug border colors
//        contentView.wantsLayer = true
//        contentView.layer?.borderWidth = 1
//        contentView.layer?.borderColor = CGColor(red: 1, green: 0, blue: 1, alpha: 1)
        
        leftPanelView.wantsLayer = true
        leftPanelView.layer?.borderWidth = 2
        leftPanelView.layer?.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        mainPanelView.wantsLayer = true
        mainPanelView.layer?.borderWidth = 2
        mainPanelView.layer?.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        rightPanelView.wantsLayer = true
        rightPanelView.layer?.borderWidth = 2
        rightPanelView.layer?.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
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
