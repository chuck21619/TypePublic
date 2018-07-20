//
//  ResizeWindowBehavior.swift
//  Panels
//
//  Created by charles johnston on 7/4/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class ResizeWindowBehavior: ResizeBehavior {
    
    var delegate: ResizeBehaviorDelegate
    
    private var initialMouseLocation: NSPoint = .zero
    private var initialPanelsDimensions = PanelsDimensions(windowFrame: nil, leftPanelWidth: nil, rightPanelWidth: nil)
    private var animatingSnap = false
    private var resizingSides: [Side] = []
    private let resizingCalculator = ResizingCalculator()
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
    // MARK: - Panel Resizing
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let resizeHandler = LeftResizingHandler()
        self.handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: leftPanel)
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let resizeHandler = RightResizingHandler()
        self.handlePanelResize(gesture: sender, resizeHandler: resizeHandler, panel: rightPanel)
    }
    
    private func handlePanelResize(gesture: NSPanGestureRecognizer, resizeHandler: HorizontalResizingHandler, panel: Panel) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if gesture.state == .began {
            
            self.configureForPanelResizing()
            return
        }
        
        let windowFrame = self.resizingCalculator.panelResizingWindowFrame(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let leftPanelWidth = self.resizingCalculator.panelResizingLeftPanelWidth(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let rightPanelWidth = self.resizingCalculator.panelResizingRightPanelWidth(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let panelsDimensions = PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: leftPanelWidth, rightPanelWidth: rightPanelWidth)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        if gesture.state == .ended {
            
            self.handleEndOfPanelResizing(horizontalResizingHandler: resizeHandler, panel: panel, currentPanelsDimensions: currentPanelsDimensions)
        }
    }
    
    private func configureForPanelResizing() {
        
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
        self.initialMouseLocation = NSEvent.mouseLocation
        self.delegate.setAutomaticResizing(true)
    }
    
    private func handleEndOfPanelResizing(horizontalResizingHandler: HorizontalResizingHandler, panel: Panel, currentPanelsDimensions: PanelsDimensions) {
        
        let panelWidth = horizontalResizingHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
        
        let shouldHidePanel = self.resizingCalculator.shouldHidePanel(panelWidth: panelWidth, panel: panel)
        let shouldExpandPanel = self.resizingCalculator.shouldExpandPanel(panelWidth: panelWidth, panel: panel)
        let shouldBounceBackFromElasticity = self.resizingCalculator.shouldBounceBackFromElasticity(panelWidth: panelWidth)
        
        if shouldHidePanel || shouldExpandPanel {
            
            self.setPanelHidden(hidden: shouldHidePanel, panel: panel, animated: true, horizontalResizingHandler: horizontalResizingHandler)
        }
        else if shouldBounceBackFromElasticity {
            
            guard let newFrame = horizontalResizingHandler.panelResizingFrameToBounceBackTo(initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinate: NSEvent.mouseLocation.x) else {
                
                return
            }
            
            self.delegate.didUpdate(panelsDimensions: newFrame, animated: true)
        }
    }
    
    private func setPanelHidden(hidden: Bool, panel: Panel, animated: Bool, horizontalResizingHandler: HorizontalResizingHandler) {
        
        let panelsDimensions = self.resizingCalculator.panelResizingHiddenPanelPanelsDimensions(panel: panel, hidden: hidden, horizontalResizingHandler: horizontalResizingHandler, initialPanelsDimensions: self.initialPanelsDimensions)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: animated)
    }
    
    // MARK: - Window Resizing
    func didStartWindowResize(_ sides: [Side]) {
        
        self.initialMouseLocation = NSEvent.mouseLocation
        self.resizingSides = sides
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
    }
    
    func didEndWindowResize(minimumSize: NSSize) {
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        let shouldBounceBack = self.resizingCalculator.windowResizingShouldCalculateElastically(frameSize: (currentPanelsDimensions.windowFrame?.size ?? .zero), minimumSize: minimumSize)
        
        if shouldBounceBack.x || shouldBounceBack.y {
            
            let newFrame = self.resizingCalculator.windowResizingFrame(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, minimumSize: minimumSize, resizingSides: self.resizingSides)
            
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
        }
    }
    
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let shouldCalculateElastically = self.resizingCalculator.windowResizingShouldCalculateElastically(frameSize: frameSize, minimumSize: minimumSize)
        
        // if attempting to resize to a width or height smaller than allowed - move window frame instead (elastically)
        if shouldCalculateElastically.x || shouldCalculateElastically.y {
            
            self.delegate.setAutomaticResizing(false)
            let newFrame = self.resizingCalculator.windowResizingElasticFrame(shouldCalculateXAxisElastically: shouldCalculateElastically.x, frameSize: frameSize, minimumSize: minimumSize, shouldCalculateYAxisElastically: shouldCalculateElastically.y, currentPanelsDimensions: self.delegate.currentPanelsDimensions(), initialPanelsDimensions: self.initialPanelsDimensions, resizingSides: self.resizingSides)
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
            
            return newFrame.size
        }
        else {
            
            self.delegate.setAutomaticResizing(true)
            return frameSize
        }
    }
    
    // MARK: - Toggle Panels
    func toggleLeftPanel(_ panel: Panel) {
        
        let resizingHandler = LeftResizingHandler()
        togglePanel(panel, horizontalResizingHandler: resizingHandler)
    }
    
    func toggleRightPanel(_ panel: Panel) {
        
        let resizingHandler = RightResizingHandler()
        togglePanel(panel, horizontalResizingHandler: resizingHandler)
    }
    
    private func togglePanel(_ panel: Panel, horizontalResizingHandler: HorizontalResizingHandler) {
        
        var newPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if panelIsHidden(horizontalResizingHandler) {
            
            newPanelsDimensions = horizontalResizingHandler.setRelevantPanelWidth(panelsDimensions: newPanelsDimensions, width: panel.defaultWidth)
            newPanelsDimensions.windowFrame = newPanelsDimensions.windowFrame?.addedWidth(panel.defaultWidth)
        }
        else {
            
            let currentWidth = horizontalResizingHandler.relevantPanelWidth(panelsDimensions: newPanelsDimensions) ?? 0
            newPanelsDimensions = horizontalResizingHandler.setRelevantPanelWidth(panelsDimensions: newPanelsDimensions, width: 0)
            newPanelsDimensions.windowFrame = newPanelsDimensions.windowFrame?.subtractedWidth(currentWidth)
        }
        
        self.delegate.didUpdate(panelsDimensions: newPanelsDimensions, animated: true)
    }
    
    private func panelIsHidden(_ horizontalResizingHandler: HorizontalResizingHandler) -> Bool {
        return horizontalResizingHandler.relevantPanelWidth(panelsDimensions: self.delegate.currentPanelsDimensions()) ?? 0 < 1
    }
}
