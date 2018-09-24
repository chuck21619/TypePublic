//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView, ResizeBehaviorDelegate, NSWindowDelegate {
    
    // MARK: - Public Interface
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
    
    // MARK: Constructors
    private func commonInit() {
        
        var topLevelObjects: NSArray? = NSArray()
        let bundle = Bundle(for: Panels.self)
        bundle.loadNibNamed(String(describing: Panels.self), owner: self, topLevelObjects: &topLevelObjects)
        
        contentView.frame = self.bounds
        addSubview(contentView)
        
        resizeBehavior = ResizeBehavior(delegate: self)
        self.setAutomaticResizing(true)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    // MARK: - properties
    // outlets
    @IBOutlet var leftPanelViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var rightPanelViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var mainPanelViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: NSView!
    
    @IBOutlet weak var leftPanelView: NSView!
    @IBOutlet weak var mainPanelView: NSView!
    @IBOutlet weak var rightPanelView: NSView!
    
    @IBOutlet weak var resizeBarLeft: ResizeBar!
    @IBOutlet weak var resizeBarRight: ResizeBar!
    
    // resizing
    private var windowState: WindowState = WindowedWindowState() // TODO: get state from settings or whatever the startup pipeline is
    private var elasticity: Float = 0.25
    private var resizeBehavior: ResizeBehavior?
    private var animating = false
    private var preventPanelResizing = false
    
    // MARK: - Resizing gestures
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let leftPanel = self.leftPanel else {
            return
        }
        
        configureConstraintsFromResizeBarGesture(gesture: sender, panelConstraint: leftPanelViewWidthConstraint)
        
        resizeBehavior?.handleResizeLeft(sender, leftPanel: leftPanel)
    }
    
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let rightPanel = self.rightPanel else {
            return
        }
        
        configureConstraintsFromResizeBarGesture(gesture: sender, panelConstraint: rightPanelViewWidthConstraint)
        
        resizeBehavior?.handleResizeRight(sender, rightPanel: rightPanel)
    }
    
    // MARK: - Configure Constraints
    func configureConstraintsFromResizeBarGesture(gesture: NSPanGestureRecognizer, panelConstraint: NSLayoutConstraint) {
        
        if gesture.state == .began {
            
            configureConstraintsForPanelResizing(panelConstraint: panelConstraint)
        }
        else if gesture.state == .ended {
            
            configureConstraintsForWindowResizing()
        }
    }
    
    private func configureConstraintsForPanelResizing(panelConstraint: NSLayoutConstraint) {
        
        
        
        if isFullScreen() {
            
            mainPanelViewWidthConstraint.isActive = false
        }
        else {
            
            let newLeftPanelWidth = leftPanelViewWidthConstraint.constant
            let newRightPanelWidth = rightPanelViewWidthConstraint.constant
            let mainPanelWidth = (self.window?.frame.width ?? 0) - (newLeftPanelWidth + newRightPanelWidth)
            mainPanelViewWidthConstraint.constant = mainPanelWidth
            mainPanelViewWidthConstraint.isActive = true
            panelConstraint.isActive = false
        }
    }
    
    private func configureConstraintsForWindowResizing() {
        
        rightPanelViewWidthConstraint.constant = rightPanelView.frame.width
        leftPanelViewWidthConstraint.constant = leftPanelView.frame.width
        
        leftPanelViewWidthConstraint.isActive = true
        rightPanelViewWidthConstraint.isActive = true
        
        mainPanelViewWidthConstraint.isActive = false
    }
    
    private func configureConstraintsForAnimation(newPanelsDimensions: PanelsDimensions) {
        
        if isFullScreen() {
            
        }
        else {
            
            if let leftPanelWidth = newPanelsDimensions.leftPanelWidth, leftPanelWidth != leftPanelViewWidthConstraint.constant {
                
                leftPanelViewWidthConstraint.isActive = false
            }
            
            if let rightPanelWidth = newPanelsDimensions.rightPanelWidth, rightPanelWidth != rightPanelViewWidthConstraint.constant {
                
                rightPanelViewWidthConstraint.isActive = false
            }
            
            let newLeftPanelWidth = newPanelsDimensions.leftPanelWidth ?? leftPanelViewWidthConstraint.constant
            let newRightPanelWidth = newPanelsDimensions.rightPanelWidth ?? rightPanelViewWidthConstraint.constant
            let mainPanelWidth = (newPanelsDimensions.windowFrame?.width ?? 0) - (newLeftPanelWidth + newRightPanelWidth)
            
            mainPanelViewWidthConstraint.constant = mainPanelWidth
            mainPanelViewWidthConstraint.isActive = true
        }
    }
    
    // MARK: - etc
    // helper method
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
    
    private func isFullScreen() -> Bool {
        
        return false
        return self.window?.styleMask.contains(.fullScreen) == true
    }
    
    //MARK: - Resize Behavior Delegate
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
    
    //MARK: - Handle updates to PanelsDimensions
    //MARK: Animated
    private func animateUI(_ panelsDimensions: PanelsDimensions) {
        
        animating = true
        
        configureConstraintsForAnimation(newPanelsDimensions: panelsDimensions)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            
            context.allowsImplicitAnimation = false
            context.duration = 0.17
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            
            if isFullScreen() {
                
                animatePanelWidthIfNeeded(panelWidth: panelsDimensions.leftPanelWidth, panelWidthConstraint: leftPanelViewWidthConstraint)
                animatePanelWidthIfNeeded(panelWidth: panelsDimensions.rightPanelWidth, panelWidthConstraint: rightPanelViewWidthConstraint)
            }
            else {
                
                if let windowFrame = panelsDimensions.windowFrame, windowFrame != self.window?.frame {
                    
                    self.window?.animator().setFrame(windowFrame, display: true)
                }
            }
        }) {
            
            self.configureConstraintsForWindowResizing()
            
            self.animating = false
        }
        return
    }
    
    private func animatePanelWidthIfNeeded(panelWidth: CGFloat?, panelWidthConstraint: NSLayoutConstraint) {
        
        guard let panelWidth = panelWidth, panelWidth != panelWidthConstraint.constant else {
            return
        }
        
        panelWidthConstraint.animator().setValue(panelWidth, forKey: "constant")
    }
    
    // MARK: Non-Animated
    private func updateUI(_ panelsDimensions: PanelsDimensions) {
        
        if isFullScreen() {
            
            updatePanelWidthInFullScreenIfNeeded(newPanelWidth: panelsDimensions.leftPanelWidth, panelWidthConstraint: leftPanelViewWidthConstraint, otherOtherWidthConstraint: rightPanelViewWidthConstraint)
            updatePanelWidthInFullScreenIfNeeded(newPanelWidth: panelsDimensions.rightPanelWidth, panelWidthConstraint: rightPanelViewWidthConstraint, otherOtherWidthConstraint: leftPanelViewWidthConstraint)
        }
        else {
            
            guard let windowFrame = panelsDimensions.windowFrame, let window = window as? PanelsWindow, windowFrame != self.window?.frame else {
                return
            }
            
            window.setFrameOverride(windowFrame, display: false)
        }
    }
    
    private func shouldUpdatePanelWidthInFullScreen(newPanelWidth: CGFloat, panelWidthConstraint: NSLayoutConstraint, otherPanelWidth: CGFloat) -> Bool {
        
        guard newPanelWidth != panelWidthConstraint.constant else {
            return false
        }
        
        let windowWidth = self.window?.frame.width ?? 0
        let newMainPanelWidth = windowWidth - (newPanelWidth + otherPanelWidth)
        
        return newMainPanelWidth > mainPanel?.defaultWidth ?? 0
    }
    
    private func updatePanelWidthInFullScreenIfNeeded(newPanelWidth: CGFloat?, panelWidthConstraint: NSLayoutConstraint, otherOtherWidthConstraint: NSLayoutConstraint) {
        
        guard let newPanelWidth = newPanelWidth, shouldUpdatePanelWidthInFullScreen(newPanelWidth: newPanelWidth, panelWidthConstraint: panelWidthConstraint, otherPanelWidth: otherOtherWidthConstraint.constant) else {
            return
        }
        
        panelWidthConstraint.constant = newPanelWidth
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
