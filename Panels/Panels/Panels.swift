//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView, ResizeBehaviorDelegate, NSWindowDelegate {
    
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
    
    public func toggleLeftPanel() {
        
        guard let leftPanel = self.leftPanel else {
            return
        }
        
        self.resizeBehavior?.toggleLeftPanel(leftPanel)
    }
    
    public func toggleRightPanel() {
        
        guard let rightPanel = self.rightPanel else {
            return
        }
        
        self.resizeBehavior?.toggleRightPanel(rightPanel)
    }
    
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
    private var preventPanelResizing = false
    
    // MARK: Resizing gestures
    private func shouldResizePanel(_ sender: NSPanGestureRecognizer) -> Bool {
        
        // when mouse clicks are on the title bar, the window is being moved
        // so panel resizing should be disabled
        if sender.state == .began {
            
            let mouseLocationY = NSEvent.mouseLocation.y
            
            let topOfWindow = (self.window?.frame.maxY ?? 0)
            
            if (topOfWindow - mouseLocationY) <= 25 {
                preventPanelResizing = true
                return false
            }
        }
        
        if sender.state == .ended && preventPanelResizing == true {
            preventPanelResizing = false
            return false
        }
        
        guard preventPanelResizing == false else {
            return false
        }
        
        return true
    }
    
    
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let leftPanel = self.leftPanel else {
            return
        }
        
        if sender.state == .began {
            
            self.leftPanelViewWidthConstraint.isActive = false
            beginPanelResizing()
        }
        else if sender.state == .ended {
            
            endPanelResizing()
        }
        
        resizeBehavior?.handleResizeLeft(sender, leftPanel: leftPanel)
    }
    
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let rightPanel = self.rightPanel else {
            return
        }
        
        if sender.state == .began {
            
            self.rightPanelViewWidthConstraint.isActive = false
            beginPanelResizing()
        }
        else if sender.state == .ended {
            
            endPanelResizing()
        }
        
        resizeBehavior?.handleResizeRight(sender, rightPanel: rightPanel)
    }
    
    var widthhhhConstraint: NSLayoutConstraint? = nil
    func beginPanelResizing() {
        
        let newLeftPanelWidth = leftPanelViewWidthConstraint.constant
        let newRightPanelWidth = rightPanelViewWidthConstraint.constant
        let mainPanelWidth = (self.window?.frame.width ?? 0) - (newLeftPanelWidth + newRightPanelWidth)
        widthhhhConstraint = mainPanelView.widthAnchor.constraint(equalToConstant: mainPanelWidth)
        
        if !isFullScreen() {
            widthhhhConstraint?.isActive = true
        }
    }
    
    func endPanelResizing() {
        
        rightPanelViewWidthConstraint.constant = rightPanelView.frame.width
        leftPanelViewWidthConstraint.constant = leftPanelView.frame.width
        
        leftPanelViewWidthConstraint.isActive = true
        rightPanelViewWidthConstraint.isActive = true
        
        if !self.isFullScreen() {
            widthhhhConstraint?.isActive = false
        }
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
    
    public func defaultSize() -> NSSize {
        
        let defaultWidth = (leftPanel?.defaultWidth ?? 0) + (rightPanel?.defaultWidth ?? 0) + (mainPanel?.defaultWidth ?? 0)
        let defaultHeight = minimumFrameSize().height
        
        return NSSize(width: defaultWidth, height: defaultHeight)
    }
    
    public func minimumFrameSize() -> NSSize {
        
        let minimumFrameWidth = (currentPanelsDimensions().leftPanelWidth ?? 0) +
                                (currentPanelsDimensions().rightPanelWidth ?? 0) +
                                (self.mainPanel?.defaultWidth ?? 0)
        
        let minimumFrameHeight = max((leftPanel?.minimumHeight ?? 0), (rightPanel?.minimumHeight ?? 0), (mainPanel?.minimumHeight ?? 0))
        
        return NSSize(width: minimumFrameWidth, height: minimumFrameHeight)
    }
    
    private func resizingSides() -> [Side] {
        
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
        
        return sides
    }
    
    // MARK: Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: String(describing: Panels.self)), owner: self, topLevelObjects: &topLevelObjects)
        
        contentView.frame = self.bounds
        addSubview(contentView)
        
        resizeBehavior = ResizeWindowBehavior(delegate: self)
        self.setAutomaticResizing(true)
        
        // debug border colors
//        contentView.wantsLayer = true
//        contentView.layer?.borderWidth = 1
//        contentView.layer?.borderColor = CGColor(red: 1, green: 0, blue: 1, alpha: 1)
        
//        leftPanelView.wantsLayer = true
//        leftPanelView.layer?.borderWidth = 2
//        leftPanelView.layer?.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
//        mainPanelView.wantsLayer = true
//        mainPanelView.layer?.borderWidth = 2
//        mainPanelView.layer?.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
//        rightPanelView.wantsLayer = true
//        rightPanelView.layer?.borderWidth = 2
//        rightPanelView.layer?.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func isFullScreen() -> Bool {
        
        return self.window?.styleMask.contains(.fullScreen) == true
    }
    
    //MARK: - Resize Behavior Delegate
    fileprivate func animateUI(_ panelsDimensions: PanelsDimensions) {
        animating = true
        
        let newLeftPanelWidth = panelsDimensions.leftPanelWidth ?? leftPanelViewWidthConstraint.constant
        let newRightPanelWidth = panelsDimensions.rightPanelWidth ?? rightPanelViewWidthConstraint.constant
        let mainPanelWidth = (panelsDimensions.windowFrame?.width ?? 0) - (newLeftPanelWidth + newRightPanelWidth)
        let widthConstraint = mainPanelView.widthAnchor.constraint(equalToConstant: mainPanelWidth)
        
        if !isFullScreen() {
            widthConstraint.isActive = true
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            
            context.allowsImplicitAnimation = false
            context.duration = 0.17
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            if isFullScreen() {
                
                if let leftPanelWidth = panelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
                    
                    leftPanelViewWidthConstraint.animator().setValue(leftPanelWidth, forKey: "constant")
                }
                
                if let rightPanelWidth = panelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
                    
                    rightPanelViewWidthConstraint.animator().setValue(rightPanelWidth, forKey: "constant")
                }
            }
            else {
                
                if let leftPanelWidth = panelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
                    
                    leftPanelViewWidthConstraint.isActive = false
                }
                
                if let rightPanelWidth = panelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
                    
                    rightPanelViewWidthConstraint.isActive = false
                }
                
                if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame {
                    
                    self.window?.animator().setFrame(windowFrame, display: true)
                }
            }
        }) {
            
            if !self.isFullScreen() {
                widthConstraint.isActive = false
                
                self.leftPanelViewWidthConstraint.constant = max(0, self.leftPanelView.frame.width)
                self.leftPanelViewWidthConstraint.isActive = true
                
                self.rightPanelViewWidthConstraint.constant = max(0, self.rightPanelView.frame.width)
                self.rightPanelViewWidthConstraint.isActive = true
            }
            
            self.animating = false
        }
        return
    }
    
    fileprivate func updateUI(_ panelsDimensions: PanelsDimensions) {
        
        if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame, !isFullScreen() {
            
            guard let window = self.window as? PanelsWindow else {
                return
            }
            
            window.setFrameOverride(windowFrame, display: false)
        }
        /*
        if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame, !isFullScreen() {
            
            guard let window = self.window as? PanelsWindow else {
                return
            }
            
            window.setFrameOverride(windowFrame, display: false)
        }
        
        if let leftPanelWidth = panelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
            
            if isFullScreen() {
                guard (self.window?.frame.width ?? 0) - (leftPanelWidth + rightPanelViewWidthConstraint.constant) > (mainPanel?.defaultWidth ?? 0) else {
                    return
                }
            }
            
            leftPanelViewWidthConstraint.constant = leftPanelWidth
        }
        
        if let rightPanelWidth = panelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
            
            if isFullScreen() {
                guard (self.window?.frame.width ?? 0) - (rightPanelWidth + leftPanelViewWidthConstraint.constant) > (mainPanel?.defaultWidth ?? 0) else {
                    return
                }
            }
            
            rightPanelViewWidthConstraint.constant = rightPanelWidth
        }
 */
    }
    
    func didUpdate(panelsDimensions: PanelsDimensions, animated: Bool) {
        
        guard animating == false else {
            return
        }
        
        if animated {
            
            return animateUI(panelsDimensions)
        }
        else {
            
            updateUI(panelsDimensions)
        }
    }

    func currentPanelsDimensions() -> PanelsDimensions {
        
        let leftPanelWidth = self.leftPanelView.frame.width
        let rightPanelWidth = self.rightPanelView.frame.width
        let windowFrame = self.window?.frame
        
        return PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: leftPanelWidth, rightPanelWidth: rightPanelWidth)
    }
    
    func setAutomaticResizing(_ enabled: Bool) {
        
        guard let panelsWindow = self.window as? PanelsWindow else {
            return
        }
        
        panelsWindow.ignoreStandardResize = !enabled
    }
    
    // MARK: - NSWindowDelegate
    public func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {

        return resizeBehavior?.handleWindowResize(frameSize: frameSize, minimumSize: self.minimumFrameSize()) ?? frameSize
    }
    
    public override func viewWillStartLiveResize() {
        
        guard animating == false else {
            return
        }
        
        resizeBehavior?.didStartWindowResize(resizingSides())
    }
    
    public override func viewDidEndLiveResize() {
        
        guard animating == false else {
            return
        }
        
        if let window = self.window as? PanelsWindow {
            
            window.ignoreStandardResize = false
        }
        
        resizeBehavior?.didEndWindowResize(minimumSize: self.minimumFrameSize())
    }
}
