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
    
    private var initialPanelWidth: CGFloat = 0
    private var initialResizingFrame: NSRect = .zero
    private var initialMouseLocation: NSPoint = .zero
    private var animatingSnap = false
    
    var magneticWhileResizing: Bool = true
    var magneticWhileResizingThreshold: CGFloat = 30
    
    required init(delegate: ResizeBehaviorDelegate) {
        
        self.delegate = delegate
    }
    
//    func animate(to width: CGFloat, from gesture: NSPanGestureRecognizer) {
//
//        guard animatingSnap == false else {
//
//            return
//        }
//
//        animatingSnap = true
//
//        var leftWidth = self.delegate.currentPanelsDimensions().leftPanelWidth ?? 0
//
//        while abs(leftWidth-width) >= 10 {
//
//
//        }
//
//        animatingSnap = false
//    }
    
    func handleResizeLeft(_ sender: NSPanGestureRecognizer, leftPanel: Panel) {
        
        let resizeHandler = LeftResizeHandler()
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if sender.state == .began {
            
            self.initialPanelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        //standard resizing
        var mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        // do not allow resizing past window
        mouseLocationDifference = resizeHandler.adjustmentToPreventResizingPastWindow(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        
        if magneticWhileResizing {
            
            let width = initialPanelWidth + mouseLocationDifference
            
            //magnetic towards default width
            let defaultWidthDifference = width - leftPanel.defaultWidth
            let absoluteDefaultWidthDifference = abs(defaultWidthDifference)
            
            if absoluteDefaultWidthDifference <= magneticWhileResizingThreshold {
                
                mouseLocationDifference = resizeHandler.adjustmentToSnapToDefaultWidth(defaultWidthDifference: defaultWidthDifference, mouseXCoordinateDifference: mouseLocationDifference)
                
                if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) != leftPanel.defaultWidth {
                    
//                    animate(to: leftPanel.defaultWidth, from: sender)
                    print("snapped to default width \(width)")
                }
            }
            
            //magnetic towards hidden width
            let hiddenWidthDifference = width - 0 //0 is a hidden width
            let absoluteHiddenWidthDifference = abs(hiddenWidthDifference)
            
            if absoluteHiddenWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference = resizeHandler.adjustmentToSnapToHiddenWidth(hiddenWidthDifference: hiddenWidthDifference, mouseXCoordinateDifference: mouseLocationDifference)
                
                if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) != 0 {
                    
//                    animate(to: 0, from: sender)
                    print("snapped to hidden width \(width)")
                }
            }
            
            if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) == leftPanel.defaultWidth &&
                (initialPanelWidth + mouseLocationDifference) != leftPanel.defaultWidth {
                
                print("snapped away from default width")
            }
            
            if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) == 0 &&
                (resizeHandler.calcRelevantPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)) != 0{
                
                print("snapped away from hidden width")
            }
        }
        
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = resizeHandler.calcWindowWidth(initialWindowWidth: self.initialResizingFrame.width, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: self.initialResizingFrame.minX, mouseXCoordinateDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        let leftPanelWidth = resizeHandler.calcLeftPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        let rightPanelWidth = resizeHandler.calcRightPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: leftPanelWidth,
                                                rightPanelWidth: rightPanelWidth)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        //auto-hide/show
        if sender.state == .ended {
            
            let panelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            
            //hide
            if panelWidth < leftPanel.hidingThreshold {
                
                //calculate new frame
                let frame = currentPanelsDimensions.windowFrame ?? .zero
                
                let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToSubtract: panelWidth)
                let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                let newSize = NSSize(width: frame.width - panelWidth, height: frame.height)
                let newFrame = NSRect(origin: newOrigin, size: newSize)
                
                let panelsDimensions = resizeHandler.calcHiddenPanelPanelsDimensions(windowFrame: newFrame)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
            //show
            else if panelWidth < leftPanel.defaultWidth {
                
                //calculate new frame
                let frame = currentPanelsDimensions.windowFrame ?? .zero
                let widthToAdd = leftPanel.defaultWidth - panelWidth
                let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToAdd: widthToAdd)
                let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                let newSize = NSSize(width: frame.width + widthToAdd, height: frame.height)
                let newFrame = NSRect(origin: newOrigin, size: newSize)
                
                let panelsDimensions = resizeHandler.calcDefaultPanelPanelsDimensions(windowFrame: newFrame, panel: leftPanel)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
        }
    }
    
    func handleResizeRight(_ sender: NSPanGestureRecognizer, rightPanel: Panel) {
        
        let resizeHandler = RightResizeHandler()
        
        let currentPanelsDimensions = self.delegate.currentPanelsDimensions()
        
        if sender.state == .began {
            
            self.initialPanelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            self.initialResizingFrame = currentPanelsDimensions.windowFrame ?? .zero
            self.initialMouseLocation = NSEvent.mouseLocation
            return
        }
        
        //standard resizing
        var mouseLocationDifference = NSEvent.mouseLocation.x - initialMouseLocation.x
        
        // do not allow resizing past window
        mouseLocationDifference = resizeHandler.adjustmentToPreventResizingPastWindow(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        
        if magneticWhileResizing {
            
            let width = initialPanelWidth - mouseLocationDifference
            
            //magnetic towards default width
            let defaultWidthDifference = width - rightPanel.defaultWidth
            let absoluteDefaultWidthDifference = abs(defaultWidthDifference)
            
            if absoluteDefaultWidthDifference <= magneticWhileResizingThreshold {
                
                mouseLocationDifference = resizeHandler.adjustmentToSnapToDefaultWidth(defaultWidthDifference: defaultWidthDifference, mouseXCoordinateDifference: mouseLocationDifference)
                
                if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) != rightPanel.defaultWidth {
                    
                    //                    animate(to: rightPanel.defaultWidth, from: sender)
                    print("snapped to default width \(width)")
                }
            }
            
            //magnetic towards hidden width
            let hiddenWidthDifference = width - 0 //0 is a hidden width
            let absoluteHiddenWidthDifference = abs(hiddenWidthDifference)
            
            if absoluteHiddenWidthDifference <= magneticWhileResizingThreshold {
                mouseLocationDifference = resizeHandler.adjustmentToSnapToHiddenWidth(hiddenWidthDifference: hiddenWidthDifference, mouseXCoordinateDifference: mouseLocationDifference)
                
                if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) != 0 {
                    
                    //                    animate(to: 0, from: sender)
                    print("snapped to hidden width \(width)")
                }
            }
            
            if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) == rightPanel.defaultWidth &&
                (initialPanelWidth + mouseLocationDifference) != rightPanel.defaultWidth {
                
                print("snapped away from default width")
            }
            
            if (resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0) == 0 &&
                (resizeHandler.calcRelevantPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)) != 0{
                
                print("snapped away from hidden width")
            }
        }
        
        let frame = currentPanelsDimensions.windowFrame ?? .zero
        let width = resizeHandler.calcWindowWidth(initialWindowWidth: self.initialResizingFrame.width, mouseXCoordinateDifference: mouseLocationDifference)
        let xCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: self.initialResizingFrame.minX, mouseXCoordinateDifference: mouseLocationDifference)
        let newFrame = NSRect(x: xCoordinate, y: frame.minY, width: width, height: frame.height)
        
        let leftPanelWidth = resizeHandler.calcLeftPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        let rightPanelWidth = resizeHandler.calcRightPanelWidth(initialPanelWidth: initialPanelWidth, mouseXCoordinateDifference: mouseLocationDifference)
        let panelsDimensions = PanelsDimensions(windowFrame: newFrame,
                                                leftPanelWidth: leftPanelWidth,
                                                rightPanelWidth: rightPanelWidth)
        self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: false)
        
        //auto-hide/show
        if sender.state == .ended {
            
            let panelWidth = resizeHandler.relevantPanelWidth(panelsDimensions: currentPanelsDimensions) ?? 0
            
            //hide
            if panelWidth < rightPanel.hidingThreshold {
                
                //calculate new frame
                let frame = currentPanelsDimensions.windowFrame ?? .zero
                
                let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToSubtract: panelWidth)
                let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                let newSize = NSSize(width: frame.width - panelWidth, height: frame.height)
                let newFrame = NSRect(origin: newOrigin, size: newSize)
                
                let panelsDimensions = resizeHandler.calcHiddenPanelPanelsDimensions(windowFrame: newFrame)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
            //show
            else if panelWidth < rightPanel.defaultWidth {
                
                //calculate new frame
                let frame = currentPanelsDimensions.windowFrame ?? .zero
                let widthToAdd = rightPanel.defaultWidth - panelWidth
                let newXCoordinate = resizeHandler.calcWindowXCoordinate(initialWindowMinX: frame.minX, widthToAdd: widthToAdd)
                let newOrigin = NSPoint(x: newXCoordinate, y: frame.minY)
                let newSize = NSSize(width: frame.width + widthToAdd, height: frame.height)
                let newFrame = NSRect(origin: newOrigin, size: newSize)
                
                let panelsDimensions = resizeHandler.calcDefaultPanelPanelsDimensions(windowFrame: newFrame, panel: rightPanel)
                self.delegate.didUpdate(panelsDimensions: panelsDimensions, animated: true)
            }
        }
    }
}
