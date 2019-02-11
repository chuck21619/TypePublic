//
//  Panels.swift
//  Panels
//
//  Created by charles johnston on 6/28/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public class Panels: NSView, ResizeBehaviorDelegate, NSWindowDelegate, NSGestureRecognizerDelegate {
    
    // MARK: - Public Interface
    public var delegate: PanelsDelegate? = nil
    
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
        self.delegate = nil
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder decoder: NSCoder) {
        self.delegate = nil
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
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
//
//        if let panGestureRecognizer = gestureRecognizer as? NSPanGestureRecognizer {
//
//            let velocity = panGestureRecognizer.velocity(in: self)
//            let shouldBegin = fabs(velocity.x) > fabs(velocity.y)
//            return shouldBegin
//        }
//
//        return true
//    }

//    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
//
//        return true
//    }
    
    @IBAction func leftPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let leftPanel = self.leftPanel else {
            return
        }
        
        if sender.state == .began {
            
            self.delegate?.didStartResizing(panelPosition: .left)
        }
        
        configureConstraintsFromResizeBarGesture(gesture: sender, panelConstraint: leftPanelViewWidthConstraint)
        
        resizeBehavior?.handleResizeLeft(sender, leftPanel: leftPanel, panelsDelegate: self.delegate)
    }
    
    @IBAction func rightPanelResizing(_ sender: NSPanGestureRecognizer) {
        
        guard shouldResizePanel(sender) == true, let rightPanel = self.rightPanel else {
            return
        }
        
        if sender.state == .began {
            
            self.delegate?.didStartResizing(panelPosition: .right)
        }
        
        configureConstraintsFromResizeBarGesture(gesture: sender, panelConstraint: rightPanelViewWidthConstraint)
        
        resizeBehavior?.handleResizeRight(sender, rightPanel: rightPanel, panelsDelegate: self.delegate)
    }
    
    // MARK: - Configure Constraints
    func configureConstraintsFromResizeBarGesture(gesture: NSPanGestureRecognizer, panelConstraint: NSLayoutConstraint) {
        
        if gesture.state == .began {
            
            windowState.configureConstraintsForPanelResizing(leftPanelViewWidthConstraint: leftPanelViewWidthConstraint, rightPanelViewWidthConstraint: rightPanelViewWidthConstraint, mainPanelViewWidthConstraint: mainPanelViewWidthConstraint, relavantPanelViewConstraint: panelConstraint, window: self.window)
        }
        else if gesture.state == .ended {
            
            configureConstraintsForWindowResizing()
        }
    }
    
    private func configureConstraintsForWindowResizing() {
        
        rightPanelViewWidthConstraint.constant = rightPanelView.frame.width
        leftPanelViewWidthConstraint.constant = leftPanelView.frame.width
        
        leftPanelViewWidthConstraint.isActive = true
        rightPanelViewWidthConstraint.isActive = true
        
        mainPanelViewWidthConstraint.isActive = false
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
        
        windowState.configureConstraintsForAnimation(leftPanelViewWidthConstraint: leftPanelViewWidthConstraint, rightPanelViewWidthConstraint: rightPanelViewWidthConstraint, mainPanelViewWidthConstraint: mainPanelViewWidthConstraint, newPanelsDimensions: panelsDimensions)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            
            context.allowsImplicitAnimation = false
            context.duration = 0.17
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            
            windowState.animateUI(leftPanelViewWidthConstraint: leftPanelViewWidthConstraint, rightPanelViewWidthConstraint: rightPanelViewWidthConstraint, window: self.window, newPanelsDimensions: panelsDimensions)
        }) {
            
            self.configureConstraintsForWindowResizing()
            
            self.animating = false
        }
        return
    }
    
    //MARK: - Resize Behavior Delegate
    func didUpdate(panelsDimensions: PanelsDimensions, animated: Bool) {
        
        guard animating == false else {
            return
        }
        
        if animated {
            
            animateUI(panelsDimensions)
            return
        }
        else {
            
            windowState.updateUI(leftPanelViewWidthConstraint: leftPanelViewWidthConstraint, rightPanelViewWidthConstraint: rightPanelViewWidthConstraint, window: self.window, mainPanelDefaultWidth: mainPanel?.defaultWidth, newPanelsDimensions: panelsDimensions)
        }
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
    
    // MARK: - Window notifications
    public func windowDidEnterFullScreen(_ notification: Notification) {
        
        self.windowState = FullScreenWindowState()
    }
    
    public func windowDidExitFullScreen(_ notification: Notification) {
        
        self.windowState = WindowedWindowState()
    }
    
    // allow resizing from window edge in fullscreen
    public func windowDidUpdate(_ notification: Notification) {
        
        if self.window?.styleMask.contains(.fullScreen) == true {
            
            if NSMenu.menuBarVisible() {
                
                if self.window?.styleMask.contains(.resizable) != true {
                    
                    self.window?.styleMask.insert(.resizable)
                }
            }
            else {
                
                if self.window?.styleMask.contains(.resizable) == true {
                    
                    self.window?.styleMask.remove(.resizable)
                }
            }
        }
    }
}

