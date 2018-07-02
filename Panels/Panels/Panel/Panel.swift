//
//  Panel.swift
//  Panels
//
//  Created by charles johnston on 6/30/18.
//  Copyright © 2018 ZinStudio. All rights reserved.
//

import Foundation

public enum PanelPosition: String {
    case left
    case main
    case right
}

public class Panel: PanelInterface {
    
    public let position: PanelPosition
    public var viewController: NSViewController?
    public var minimumWidth: CGFloat
    
    var resizeable: Bool = true
    
    public required init(position: PanelPosition, minimumWidth: CGFloat = 0.0, viewController: NSViewController?) {
        
        self.position = position
        self.minimumWidth = minimumWidth
        self.viewController = viewController
        
        
        var widthConstraint: CGFloat = 0
        let views = viewController?.view.getAllSubviews()
        
        // getting the greatest width constraint
        for view in views ?? [] {
            
            for constraint in view.constraints {
                
                if constraint.firstAttribute == .width {
                    
                    if constraint.relation == .greaterThanOrEqual {
                        
                        if constraint.constant > widthConstraint {
                            
                            widthConstraint = constraint.constant
                        }
                    }
                }
            }
        }
        
        self.minimumWidth = widthConstraint
    }
}

extension NSView {
    
    class func getAllSubviews<T: NSView>(view: NSView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    func getAllSubviews<T: NSView>() -> [T] {
        return NSView.getAllSubviews(view: self) as [T]
    }
}
