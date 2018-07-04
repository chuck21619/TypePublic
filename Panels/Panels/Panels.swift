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
            self.leftPanelViewWidthConstraint.constant = leftPanel.defaultWidth
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
            self.rightPanelViewWidthConstraint.constant = rightPanel.defaultWidth
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
    @IBOutlet weak var rightPanelViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: NSView!
    
    @IBOutlet weak var leftPanelView: NSView!
    @IBOutlet weak var mainPanelView: NSView!
    @IBOutlet weak var rightPanelView: NSView!
    
    @IBOutlet weak var resizeBarLeft: ResizeBar!
    @IBOutlet weak var resizeBarRight: ResizeBar!
    
    // resizing
    var initialLeftPanelViewWidth: CGFloat = 0
    var initialRightPanelViewWidth: CGFloat = 0
    var initialResizingFrame: NSRect = .zero
    var initialMouseLocation: NSPoint = .zero
    var animatingLeftPanel = false
    var animatingRightPanel = false
    
    // MARK: - Methods
    // MARK: Resizing gestures
    // MARK: - left methods
    
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        let xCoordinate = sender.location(in: contentView).x
        
        guard xCoordinate > 0 else {
            return
        }
        
        if sender.state == .began {
            
            self.initialLeftPanelViewWidth = leftPanelView.frame.width
            self.initialResizingFrame = self.window?.frame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        let theDiff = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        if let frame = window?.frame {
            
            let newFrame = NSRect(x: frame.minX,
                                  y: frame.minY,
                                  width: self.initialResizingFrame.width + theDiff,
                                  height: frame.height)
            
            self.window?.setFrame(newFrame, display: true, animate: false)
        }
        
        leftPanelViewWidthConstraint.constant = initialLeftPanelViewWidth + theDiff
    }
    
    //MARK: right methods
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        let xCoordinate = sender.location(in: contentView).x
        
        guard xCoordinate < self.contentView.frame.width else {
            return
        }
        
        if sender.state == .began {
            
            self.initialRightPanelViewWidth = rightPanelView.frame.width
            self.initialResizingFrame = self.window?.frame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        let theDiff = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        print(theDiff)
        
        if let frame = window?.frame {
            
            let newFrame = NSRect(x: self.initialResizingFrame.minX + theDiff,
                                  y: frame.minY,
                                  width: self.initialResizingFrame.width - theDiff,
                                  height: frame.height)
            
            self.window?.setFrame(newFrame, display: true, animate: false)
        }
        
        rightPanelViewWidthConstraint.constant = initialRightPanelViewWidth - theDiff
        
    }
    
    // MARK: - etc
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
