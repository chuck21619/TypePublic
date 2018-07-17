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
        
        let windowFrame = self.resizingCalculator.calcWindowFrame(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let leftPanelWidth = self.resizingCalculator.calcLeftPanelWidth(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let rightPanelWidth = self.resizingCalculator.calcRightPanelWidth(horizontalResizingHandler: resizeHandler, initialPanelsDimensions: self.initialPanelsDimensions, initialMouseXCoordinate: self.initialMouseLocation.x, currentMouseXCoordinate: NSEvent.mouseLocation.x)
        
        let panelsDimensions = PanelsDimensions(windowFrame: windowFrame, leftPanelWidth: leftPanelWidth, rightPanelWidth: rightPanelWidth)
        
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        if gesture.state == .ended {
            
            self.handleEndOfPanelResizing(horizontalResizingHandler: resizeHandler, panel: panel, currentPanelsDimensions: currentPanelsDimensions)
        }
    }
    
    private func configureForPanelResizing() {
        
        self.initialPanelsDimensions = self.delegate.currentPanelsDimensions()
        self.initialMouseLocation = NSEvent.mouseLocation
        self.delegate.setStandardResizing(true)
    }
    
    // MARK: auto hide/show
    private func handleEndOfPanelResizing(horizontalResizingHandler: HorizontalResizingHandler, panel: Panel, currentPanelsDimensions: PanelsDimensions) {
        
        let panelWidth = horizontalResizingHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
        
        let shouldHidePanel = self.resizingCalculator.shouldHidePanel(panelWidth, panel)
        let shouldExpandPanel = self.resizingCalculator.shouldExpandPanel(panelWidth, panel)
        let shouldBounceBackFromElasticity = self.resizingCalculator.shouldBounceBackFromElasticity(panelWidth)
        
        if shouldHidePanel || shouldExpandPanel {
            
            self.setPanelHidden(hidden: shouldHidePanel, panel: panel, animated: true, horizontalResizingHandler: horizontalResizingHandler)
        }
        else if shouldBounceBackFromElasticity {
            
            guard let elasticEndFrame = self.resizingCalculator.elasticEndFrame(horizontalResizingHandler: horizontalResizingHandler, initialPanelsDimensions: self.initialPanelsDimensions, mouseXCoordinate: NSEvent.mouseLocation.x) else {
                
                return
            }
            
            self.delegate.didUpdate(panelsDimensions: elasticEndFrame, animated: true)
        }
    }
    
    private func setPanelHidden(hidden: Bool, panel: Panel, animated: Bool, horizontalResizingHandler: HorizontalResizingHandler) {
        
        let panelsDimensions = self.resizingCalculator.panelsDimensions(panel: panel, hidden: hidden, horizontalResizingHandler: horizontalResizingHandler, initialPanelsDimensions: self.initialPanelsDimensions)
        
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
        
        let shouldBounceBackVertically = self.resizingCalculator.windowResizingWidthIsLessThanMinimumWidth(currentPanelsDimensions, minimumSize)
        let shouldBounceBackHorizontally = self.resizingCalculator.windowResizingHeightIsLessThanMinimumHeight(currentPanelsDimensions, minimumSize)
        let shouldBounceBack = shouldBounceBackVertically || shouldBounceBackHorizontally
        
        if shouldBounceBack {
            
            let newFrame = self.resizingCalculator.calcWindowResizingCoordinates(initialPanelsDimensions: self.initialPanelsDimensions, currentPanelsDimensions: currentPanelsDimensions, minimumSize: minimumSize, resizingSides: self.resizingSides)
            
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
        }
    }
    
    func handleWindowResize(frameSize: NSSize, minimumSize: NSSize) -> NSSize {
        
        let shouldCalculateAxesElastically = self.resizingCalculator.shouldCalculateAxesElastically(frameSize, minimumSize)
        
        // if attempting to resize to a width or height smaller than allowed - move window frame instead (elastically)
        if shouldCalculateAxesElastically.x || shouldCalculateAxesElastically.y {
            
            let newSize = self.resizingCalculator.windowResizeSize(frameSize: frameSize, minimumSize: minimumSize)
            
            self.delegate.setStandardResizing(false)
            
            let newOrigin = self.resizingCalculator.calcElasticOrigin(shouldCalculateAxesElastically.x, newSize.width, frameSize, minimumSize, shouldCalculateAxesElastically.y, newSize.height, self.delegate.currentPanelsDimensions(), self.initialPanelsDimensions, self.resizingSides)
            let newFrame = NSRect(origin: newOrigin, size: newSize)
            let panelsDimensions = PanelsDimensions(windowFrame: newFrame, leftPanelWidth: nil, rightPanelWidth: nil)
            
            self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
            return newSize
        }
        else {
            
            self.delegate.setStandardResizing(true)
            return frameSize
        }
    }
}
