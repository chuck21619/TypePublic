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
    @IBOutlet weak var leftPanelViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPanelViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPanelViewTrailingConstraint: NSLayoutConstraint!
    
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
        
        let constraintConstantToHideLeftView = -(leftPanel?.minimumSize().width ?? 0)
        
        if leftPanelViewLeadingConstraint.constant != constraintConstantToHideLeftView {
            
            guard animatingLeftPanel == false else {
                return
            }
            
            animatingLeftPanel = true
            
            leftPanelViewLeadingConstraint.constant = constraintConstantToHideLeftView
            
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
        // expand window if panels minimium sizes dont fit
        let minimumWidthForBothPanels = (leftPanel?.minimumSize().width ?? 0) + (mainPanel?.minimumSize().width ?? 0)
        if mainPanelView.frame.width < minimumWidthForBothPanels {
            
            if let frame = self.window?.frame {
                
                let newFrame = NSRect(x: frame.minX,
                                      y: frame.minY,
                                      width: frame.width+(leftPanel?.minimumSize().width ?? 0),
                                      height: frame.height)
                
                self.window?.setFrame(newFrame, display: true, animate: true)
            }
        }
    }
    
    fileprivate func showLeftPanel() {
        leftPanelViewLeadingConstraint.constant = 0
        
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
        
        // hide left panel if cursor is passed threshold
        if xCoordinate < leftPanel?.hidingThreshold ?? 0 {
            
            hideLeftPanel()
        }
        
        // show left panel is cursor is within threshold
        if xCoordinate > leftPanel?.hidingThreshold ?? 0 {
            
            
            if leftPanelViewLeadingConstraint.constant != 0 {
                
                guard animatingLeftPanel == false else {
                    return
                }
                
                expandWindowIfNeededToIncludeLeftPanel()
                
                animatingLeftPanel = true
                
                showLeftPanel()
            }
        }
        
        
        // do not resize to the left of leftPanel's minimumWidth
        let minimumWidth = leftPanel?.minimumSize().width ?? 0
        guard xCoordinate > minimumWidth  else {
            
            // the gesture event may not update at the exact time the curser is on the edge
            if leftPanelViewWidthConstraint.constant != minimumWidth {
                
                leftPanelViewWidthConstraint.constant = minimumWidth
            }
            
            return
        }
        
        // do not resize to the right of mainPanels minimumWidth
        let maximumValidConstraint = mainPanelView.frame.maxX - (mainPanel?.minimumSize().width ?? 0)
        guard xCoordinate < maximumValidConstraint else {
            
            // the gesture event may not update at the exact time the curser is on the edge
            if leftPanelViewWidthConstraint.constant != maximumValidConstraint {
                
                leftPanelViewWidthConstraint.constant = maximumValidConstraint
            }
            return
        }
        
        leftPanelViewWidthConstraint.constant = xCoordinate
    }
    
    //MARK: right methods
    fileprivate func hideRightPanel() {
        
        let constraintConstantToHideRightView = -(rightPanel?.minimumSize().width ?? 0)
        
        if rightPanelViewTrailingConstraint.constant != constraintConstantToHideRightView {
            
                guard animatingRightPanel == false else {
                    return
                }
            
                animatingRightPanel = true
            
            rightPanelViewTrailingConstraint.constant = constraintConstantToHideRightView
            
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
        // expand window if panels minimium sizes dont fit
        let minimumWidthForBothPanels = (rightPanel?.minimumSize().width ?? 0) + (mainPanel?.minimumSize().width ?? 0)
        if mainPanelView.frame.width < minimumWidthForBothPanels {
            if let frame = self.window?.frame {
                
                let newFrame = NSRect(x: frame.minX-(minimumWidthForBothPanels-mainPanelView.frame.width),
                                      y: frame.minY,
                                      width: frame.width+(rightPanel?.minimumSize().width ?? 0),
                                      height: frame.height)
                self.window?.setFrame(newFrame, display: true, animate: true)
            }
        }
    }
    
    fileprivate func showRightPanel() {
        //show right panel
        rightPanelViewTrailingConstraint.constant = 0
        
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
        
        
        // hide right panel if cursor is passed threshold
        if xCoordinate > contentView.frame.width - (rightPanel?.hidingThreshold ?? 0) {
            
            hideRightPanel()
        }
        
        // show right panel is cursor is within threshold
        if xCoordinate < contentView.frame.width - (rightPanel?.hidingThreshold ?? 0) {
            
            if rightPanelViewTrailingConstraint.constant != 0 {
                
                
                guard animatingRightPanel == false else {
                    return
                }
                
                expandWindowIfNeededToIncludeRightPanel()
                
                animatingRightPanel = true
                
                showRightPanel()
            }
        }
        
        // do not resize to the left of the mainPanel's minimum width
        let minimumValidXCoord = leftPanelView.frame.maxX + (mainPanel?.minimumSize().width ?? 0)
        guard xCoordinate > minimumValidXCoord else {
            
            // if the rightPanel is hidden. dont bother
            guard rightPanelViewTrailingConstraint.constant != -(rightPanel?.minimumSize().width ?? 0) else {
                return
            }
            
            // the gesture event may not update at the exact time the curser is on the edge
            if rightPanelViewWidthConstraint.constant != contentView.frame.width - (minimumValidXCoord) {
                
                rightPanelViewWidthConstraint.constant = contentView.frame.width - (minimumValidXCoord)
            }
            
            return
        }
        
        // do not resize to the right of rightPanel's minimum width
        let minimumWidth = rightPanel?.minimumSize().width ?? 0
        guard xCoordinate < contentView.frame.width - minimumWidth else {
            
            // the gesture event may not update at the exact time the curser is on the edge
            if rightPanelViewWidthConstraint.constant != minimumWidth {
                
                rightPanelViewWidthConstraint.constant = minimumWidth
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
