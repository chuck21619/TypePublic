//
//  WindowedWindowState.swift
//  Panels
//
//  Created by charles johnston on 9/24/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class WindowedWindowState: WindowState {
    
    func configureConstraintsForPanelResizing(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, relavantPanelViewConstraint: NSLayoutConstraint, window: NSWindow?) {
        
        let leftPanelWidth = leftPanelViewWidthConstraint.constant
        let rightPanelWidth = rightPanelViewWidthConstraint.constant
        let mainPanelWidth = (window?.frame.width ?? 0) - (leftPanelWidth + rightPanelWidth)
        mainPanelViewWidthConstraint.constant = mainPanelWidth
        mainPanelViewWidthConstraint.isActive = true
        relavantPanelViewConstraint.isActive = false
    }
    
    func configureConstraintsForAnimation(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, newPanelsDimensions: PanelsDimensions) {
        
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
    
    func animateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, newPanelsDimensions: PanelsDimensions) {
        
        if let windowFrame = newPanelsDimensions.windowFrame, windowFrame != window?.frame {
            
            window?.animator().setFrame(windowFrame, display: true)
        }
    }
    
    func updateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, mainPanelDefaultWidth: CGFloat?, newPanelsDimensions: PanelsDimensions) {
        
        guard let windowFrame = newPanelsDimensions.windowFrame, let panelsWindow = window as? PanelsWindow, windowFrame != window?.frame else {
            return
        }
        
        panelsWindow.setFrameOverride(windowFrame, display: false)
    }
}
