//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView, PanelsInterface, ResizeBehaviorDelegate, NSWindowDelegate {
    
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
    @IBOutlet var leftPanelViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var rightPanelViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: NSView!
    
    @IBOutlet weak var leftPanelView: NSView!
    @IBOutlet weak var mainPanelView: NSView!
    @IBOutlet weak var rightPanelView: NSView!
    
    @IBOutlet weak var resizeBarLeft: ResizeBar!
    @IBOutlet weak var resizeBarRight: ResizeBar!
    
    // resizing
    private var elasticity: Float = 0.25
    private var resizeBehavior: ResizeBehavior?
    private var animating = false
    
    // MARK: - Methods
    // MARK: Resizing gestures
    // MARK: - left methods
    
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
    
        guard let leftPanel = leftPanel else {
            return
        }
        
        resizeBehavior?.handleResizeLeft(sender, leftPanel: leftPanel)
    }
    
    //MARK: right methods
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard let rightPanel = rightPanel else {
            return
        }
        
        resizeBehavior?.handleResizeRight(sender, rightPanel: rightPanel)
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
    
    public func minimumFrameWidth() -> CGFloat {
        
        return (leftPanel?.defaultWidth ?? 0) + (rightPanel?.defaultWidth ?? 0) + (mainPanel?.defaultWidth ?? 0)
    }
    
    // MARK: Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: String(describing: Panels.self)), owner: self, topLevelObjects: &topLevelObjects)
        
        contentView.frame = self.bounds
        addSubview(contentView)
        
        resizeBehavior = ResizeWindowBehavior(delegate: self)
        
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
    
    //MARK: - Resize Behavior Delegate
    func didUpdate(panelsDimensions: PanelsDimensions, animated: Bool) {
        
        if animated {
            
            animating = true
            
            let widthConstraint = mainPanelView.widthAnchor.constraint(equalToConstant: mainPanelView.frame.width)
            widthConstraint.isActive = true
            
            NSAnimationContext.runAnimationGroup({ (context) in
                
                context.allowsImplicitAnimation = true
                context.duration = 0.25
                
                if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame {
                    
                    self.window?.animator().setFrame(windowFrame, display: true)
                }
                
                if let leftPanelWidth = panelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
                    
                    leftPanelViewWidthConstraint.isActive = false
                }
                
                if let rightPanelWidth = panelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
                    
                    rightPanelViewWidthConstraint.isActive = false
                }
            }) {
                widthConstraint.isActive = false
                
                self.leftPanelViewWidthConstraint.constant = max(0, self.leftPanelView.frame.width)
                self.leftPanelViewWidthConstraint.isActive = true
                
                self.rightPanelViewWidthConstraint.constant = max(0, self.rightPanelView.frame.width)
                self.rightPanelViewWidthConstraint.isActive = true
                
                self.animating = false
            }
            return
        }
 
        if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame {
            
            if let window = self.window as? Window {
                window.setFrameTest(windowFrame, display: false)
            }
        }
        
        if let leftPanelWidth = panelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
            
            leftPanelViewWidthConstraint.constant = leftPanelWidth
        }
        
        if let rightPanelWidth = panelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
            
            rightPanelViewWidthConstraint.constant = rightPanelWidth
        }
    }

    func currentPanelsDimensions() -> PanelsDimensions {
        
        let leftPanelWidth = self.leftPanelView.frame.width
        let rightPanelWidth = self.rightPanelView.frame.width
        let windowFrame = self.window?.frame
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: leftPanelWidth, rightPanelWidth: rightPanelWidth)
    }
    
    func setStandardResizing(_ enabled: Bool) {
        
        if let window = self.window as? Window {
            
            window.ignoreStandardResize = !enabled
        }
    }
    
    // MARK: - NSWindowDelegate
    public func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        
        let minimumFrameWidth = (currentPanelsDimensions().leftPanelWidth ?? 0) +
                                (currentPanelsDimensions().rightPanelWidth ?? 0) +
                                (self.mainPanel?.defaultWidth ?? 0)

        //TODO: define minimum height in Panel(s)
        let minimumSize = NSSize(width: minimumFrameWidth, height: 600)

        return resizeBehavior?.handleWindowResize(frameSize: frameSize, minimumSize: minimumSize) ?? frameSize
    }
    
    public override func viewWillStartLiveResize() {
        
        guard animating == false else {
            return
        }
        
        let leftEdge = self.window?.frame.minX ?? 0
        let rightEdge = self.window?.frame.maxX ?? 0
        let topEdge = self.window?.frame.maxY ?? 0
        let bottomEdge = self.window?.frame.minY ?? 0
        
        let mouseX = NSEvent.mouseLocation.x
        let mouseY = NSEvent.mouseLocation.y
        
        let leftDifference = abs(mouseX - leftEdge)
        let rightDifference = abs(mouseX - rightEdge)
        let topDifference = abs(mouseY - topEdge)
        let bottomDifference = abs(mouseY - bottomEdge)
        
        var sides: [Side] = []
        if leftDifference < rightDifference {
            sides.append(.left)
        }
        else {
            sides.append(.right)
        }
        
        if topDifference < bottomDifference {
            sides.append(.top)
        }
        else {
            sides.append(.bottom)
        }
        
        resizeBehavior?.didStartWindowResize(sides)
    }
    
    public override func viewDidEndLiveResize() {
        
        guard animating == false else {
            return
        }
        
        if let window = self.window as? Window {
            
            window.ignoreStandardResize = false
        }
        
        let minimumFrameWidth = (currentPanelsDimensions().leftPanelWidth ?? 0) +
                                (currentPanelsDimensions().rightPanelWidth ?? 0) +
                                (self.mainPanel?.defaultWidth ?? 0)
        
        //TODO: define minimum height in Panel(s)
        let minimumSize = NSSize(width: minimumFrameWidth, height: 600)
        
        resizeBehavior?.didEndWindowResize(minimumSize: minimumSize)
    }
}
