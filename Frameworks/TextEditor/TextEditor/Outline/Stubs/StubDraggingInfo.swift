//
//  StubDraggingInfo.swift
//  TextEditor
//
//  Created by charles johnston on 4/3/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

class StubDraggingInfo: NSObject, NSDraggingInfo {
    
    override init() {
        super.init()
    }
    
    var draggingDestinationWindow: NSWindow?
    
    var draggingSourceOperationMask: NSDragOperation = NSDragOperation(rawValue: 1)
    
    var draggingLocation: NSPoint = .zero
    
    var draggedImageLocation: NSPoint = .zero
    
    var draggedImage: NSImage?
    
    var draggingPasteboard: NSPasteboard = NSPasteboard(byFilteringFile: "asd")
    
    var draggingSource: Any?
    
    var draggingSequenceNumber: Int = 1
    
    func slideDraggedImage(to screenPoint: NSPoint) {
        //
    }
    
    var draggingFormation: NSDraggingFormation = NSDraggingFormation(rawValue: 1)!
    
    var animatesToDestination: Bool = false
    
    var numberOfValidItemsForDrop: Int = 1
    
    func enumerateDraggingItems(options enumOpts: NSDraggingItemEnumerationOptions = [], for view: NSView?, classes classArray: [AnyClass], searchOptions: [NSPasteboard.ReadingOptionKey : Any] = [:], using block: @escaping (NSDraggingItem, Int, UnsafeMutablePointer<ObjCBool>) -> Void) {
        //
    }
    
    var springLoadingHighlight: NSSpringLoadingHighlight = .none
    
    func resetSpringLoading() {
        //
    }
    
    
    
}
