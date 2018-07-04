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
            self.leftPanelViewWidthConstraint.constant = leftPanel.minimumSize().width
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
            self.rightPanelViewWidthConstraint.constant = rightPanel.minimumSize().width
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
    var animatingLeftPanel = false
    var animatingRightPanel = false
    
    // MARK: - Methods
    // MARK: Resizing gestures
    // MARK: - left methods
    fileprivate func hideLeftPanel() {
        
        let constraintConstantToHideLeftView: CGFloat = 0
        
        if leftPanelViewWidthConstraint.constant != constraintConstantToHideLeftView {
            
            guard animatingLeftPanel == false else {
                return
            }
            
            animatingLeftPanel = true
            
            leftPanelViewWidthConstraint.constant = constraintConstantToHideLeftView
            
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                self.contentView.layoutSubtreeIfNeeded()
            }) {
                self.animatingLeftPanel = false
            }
        }
    }
    
    fileprivate func expandWindowIfNeededToIncludeLeftPanel() {
        
        let minimumWidthForBothPanels = (leftPanel?.hidingThreshold ?? 0) + (mainPanel?.minimumSize().width ?? 0)
        if mainPanelView.frame.width < minimumWidthForBothPanels {
            
            if let frame = self.window?.frame {
                
                let newFrame = NSRect(x: frame.minX,
                                      y: frame.minY,
                                      width: frame.width+(leftPanel?.hidingThreshold ?? 0),
                                      height: frame.height)
                
                self.window?.setFrame(newFrame, display: true, animate: true)
            }
        }
    }
    
    fileprivate func showLeftPanel() {
        
        self.animatingLeftPanel = true
        
        leftPanelViewWidthConstraint.constant = leftPanel?.defaultWidth ?? leftPanelViewWidthConstraint.constant
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            self.contentView.layoutSubtreeIfNeeded()
        }) {
            self.animatingLeftPanel = false
        }
    }
    
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        let xCoordinate = sender.location(in: contentView).x
        
        if sender.state == .ended {
            
            // hide left panel if cursor is below hidden threshold
            if xCoordinate < leftPanel?.hidingThreshold ?? 0 {
                
                hideLeftPanel()
                
                return
            }
            
            // expand left panel if cursor below default width && passed hidden threshold
            if xCoordinate > (leftPanel?.hidingThreshold ?? 0)
                && xCoordinate < (leftPanel?.defaultWidth ?? 0) {
                
                expandWindowIfNeededToIncludeLeftPanel()
                
                showLeftPanel()
                
                return
            }
        }
        
        // do not resize to the left of the window
        guard xCoordinate > 0  else {

            // the gesture event may not update at the exact time the curser is on the edge
            if leftPanelViewWidthConstraint.constant != 0 {

                leftPanelViewWidthConstraint.constant = 0
            }

            return
        }
        
        leftPanelViewWidthConstraint.constant = xCoordinate
    }
    
    //MARK: right methods
    fileprivate func hideRightPanel() {
        
        let constraintConstantToHideRightView: CGFloat = 0
        
        if rightPanelViewWidthConstraint.constant != constraintConstantToHideRightView {
            
                guard animatingRightPanel == false else {
                    return
                }
            
                animatingRightPanel = true
            
            rightPanelViewWidthConstraint.constant = constraintConstantToHideRightView
            
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                self.contentView.layoutSubtreeIfNeeded()
            }) {
                self.animatingRightPanel = false
            }
        }
    }
    
    fileprivate func expandWindowIfNeededToIncludeRightPanel() {
        
        let minimumWidthForBothPanels = (rightPanel?.hidingThreshold ?? 0) + (mainPanel?.minimumSize().width ?? 0)
        if mainPanelView.frame.width < minimumWidthForBothPanels {
            if let frame = self.window?.frame {
                
                let newFrame = NSRect(x: frame.minX-(minimumWidthForBothPanels-mainPanelView.frame.width),
                                      y: frame.minY,
                                      width: frame.width+(rightPanel?.hidingThreshold ?? 0),
                                      height: frame.height)
                self.window?.setFrame(newFrame, display: true, animate: true)
            }
        }
    }
    
    fileprivate func showRightPanel() {
        
        self.animatingRightPanel = true
        
        rightPanelViewWidthConstraint.constant = rightPanel?.defaultWidth ?? rightPanelViewWidthConstraint.constant
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            self.contentView.layoutSubtreeIfNeeded()
        }) {
            self.animatingRightPanel = false
        }
    }
    
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        let xCoordinate = sender.location(in: contentView).x
        
        if sender.state == .ended {
            
            // hide right panel if cursor is passed hidden threshold
            if xCoordinate > contentView.frame.width - (rightPanel?.hidingThreshold ?? 0) {
                
                hideRightPanel()
                return
            }
            
            // expand right panel if cursor is passed default width && below hidden threshold
            if xCoordinate < contentView.frame.width - (rightPanel?.hidingThreshold ?? 0)
                && xCoordinate > contentView.frame.width - (rightPanel?.defaultWidth ?? 0) {
                
                expandWindowIfNeededToIncludeRightPanel()
                
                showRightPanel()
                
                return
            }
        }
        
        // do not resize to the right of the window
        guard xCoordinate < contentView.frame.width else {
            
            // the gesture event may not update at the exact time the curser is on the edge
            if rightPanelViewWidthConstraint.constant != 0 {
                
                rightPanelViewWidthConstraint.constant = 0
            }
            
            return
        }
        
        // expand the window towards the left when hitting the limit of the mainPanel's minimum width
        guard xCoordinate > (mainPanelView.frame.minX + (mainPanel?.minimumSize().width ?? 0)) else {
            
            if let frame = self.window?.frame {
                
                let theDiff = mainPanelView.frame.maxX - xCoordinate
                
                let newFrame = NSRect(x: frame.minX - theDiff,
                                      y: frame.minY,
                                      width: frame.width + theDiff,
                                      height: frame.height)
                
                self.window?.setFrame(newFrame, display: true, animate: false)
                
                
                rightPanelViewWidthConstraint.constant += theDiff
                
            }
            return
        }
        
        rightPanelViewWidthConstraint.constant = contentView.frame.width - xCoordinate
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
