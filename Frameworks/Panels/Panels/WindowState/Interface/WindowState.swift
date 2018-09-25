//
//  WindowState.swift
//  Panels
//
//  Created by charles johnston on 9/24/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

protocol WindowState {
    
    func configureConstraintsForPanelResizing(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, relavantPanelViewConstraint: NSLayoutConstraint, window: NSWindow?)
    
    func configureConstraintsForAnimation(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, mainPanelViewWidthConstraint: NSLayoutConstraint, newPanelsDimensions: PanelsDimensions)
    
    func animateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, newPanelsDimensions: PanelsDimensions)
    
    func updateUI(leftPanelViewWidthConstraint: NSLayoutConstraint, rightPanelViewWidthConstraint: NSLayoutConstraint, window: NSWindow?, mainPanelDefaultWidth: CGFloat?, newPanelsDimensions: PanelsDimensions)
}
