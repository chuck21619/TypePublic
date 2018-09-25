//
//  FullScreenWindowState.swift
//  Panels
//
//  Created by charles johnston on 9/24/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

class FullScreenWindowState: WindowState {
    
    func configureConstraintsForPanelResizing(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, relavantPanelViewConstraint: NSLayoutConstraint, window: NSWindow?) {
        
        mainPanelViewWidthConstraint.isActive = false
    }
    
    func configureConstraintsForAnimation(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, newPanelsDimensions: PanelsDimensions) {
        
        //do nothing
    }
    
    func animateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, newPanelsDimensions: PanelsDimensions) {
        
        animatePanelWidthIfNeeded(panelWidth: newPanelsDimensions.leftPanelWidth, panelWidthConstraint: leftPanelViewWidthConstraint)
        animatePanelWidthIfNeeded(panelWidth: newPanelsDimensions.rightPanelWidth, panelWidthConstraint: rightPanelViewWidthConstraint)
    }
    
    func updateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, mainPanelDefaultWidth: CGFloat?, newPanelsDimensions: PanelsDimensions) {
        
        updatePanelWidthInFullScreenIfNeeded(newPanelWidth: newPanelsDimensions.leftPanelWidth, panelWidthConstraint: leftPanelViewWidthConstraint, otherOtherWidthConstraint: rightPanelViewWidthConstraint, window: window, mainPanelDefaultWidth: mainPanelDefaultWidth)
        updatePanelWidthInFullScreenIfNeeded(newPanelWidth: newPanelsDimensions.rightPanelWidth, panelWidthConstraint: rightPanelViewWidthConstraint, otherOtherWidthConstraint: leftPanelViewWidthConstraint, window: window, mainPanelDefaultWidth: mainPanelDefaultWidth)
    }
    
    // MARK: - private
    private func animatePanelWidthIfNeeded(panelWidth: CGFloat?, panelWidthConstraint: NSLayoutConstraint) {
        
        guard let panelWidth = panelWidth, panelWidth != panelWidthConstraint.constant else {
            return
        }
        
        panelWidthConstraint.animator().setValue(panelWidth, forKey: "constant")
    }
    
    private func shouldUpdatePanelWidthInFullScreen(newPanelWidth: CGFloat, panelWidthConstraint: NSLayoutConstraint, otherPanelWidth: CGFloat, window: NSWindow?, mainPanelDefaultWidth: CGFloat?) -> Bool {
        
        guard newPanelWidth != panelWidthConstraint.constant else {
            return false
        }
        
        let windowWidth = window?.frame.width ?? 0
        let newMainPanelWidth = windowWidth - (newPanelWidth + otherPanelWidth)
        
        return newMainPanelWidth > mainPanelDefaultWidth ?? 0
    }
    
    private func updatePanelWidthInFullScreenIfNeeded(newPanelWidth: CGFloat?, panelWidthConstraint: NSLayoutConstraint, otherOtherWidthConstraint: NSLayoutConstraint, window: NSWindow?, mainPanelDefaultWidth: CGFloat?) {
        
        guard let newPanelWidth = newPanelWidth, shouldUpdatePanelWidthInFullScreen(newPanelWidth: newPanelWidth, panelWidthConstraint: panelWidthConstraint, otherPanelWidth: otherOtherWidthConstraint.constant, window: window, mainPanelDefaultWidth: mainPanelDefaultWidth) else {
            return
        }
        
        panelWidthConstraint.constant = newPanelWidth
    }
}
