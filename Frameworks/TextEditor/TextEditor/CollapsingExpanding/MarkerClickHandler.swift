//
//  MarkerClickHandler.swift
//  TextEditor
//
//  Created by charles johnston on 1/23/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

class MarkerClickHandler {
    
    static func markerClicked(_ marker: TextGroupMarker, outlineModel: OutlineModel?, textStorage: NSTextStorage, collapsedTextGroups: inout [TextGroup], collapsingTranslator: CollapsingTranslator?, rulerView: TestRulerView, ignoreProcessingDelegate: IgnoreProcessingDelegate) {
        
        ignoreProcessingDelegate.ignoreProcessing(ignore: true)
        
        outlineModel?.updateTextGroups(from: textStorage)
        
        guard let textGroup = outlineModel?.textGroup(at: marker.token.range.location) else {
            return
        }
        
        var textGroupIsCollapsed = false
        
        for collapsedTextGroup in collapsedTextGroups {
            
            if collapsedTextGroup.title == textGroup.title {
                textGroupIsCollapsed = true
                break
            }
        }
        
        if textGroupIsCollapsed {
            
            collapsingTranslator?.expandTextGroup(string: textStorage, textGroup: textGroup)
            outlineModel?.updateTextGroups(from: textStorage)
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            
            //re-collapse all groups inside of it that were collapsed
            for childTextGroup in updatedTextGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if collapsedTextGroup.title == childTextGroup.title {
                        
                        collapsingTranslator?.collapseTextGroup(string: textStorage, collapsedTextGroup, outlineModel: outlineModel, collapsedTextGroups: &collapsedTextGroups)
                        outlineModel?.updateTextGroups(from: textStorage)
                    }
                }
            }
            
            let indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex { (collapsedTextGroup) -> Bool in
                collapsedTextGroup.title == textGroup.title
            }
            
            if let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup {
                collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            }
        }
        else {
            
            //expand all groups inside of it that are collapsed
            for childTextGroup in textGroup.textGroups.reversed() {
                
                for collapsedTextGroup in collapsedTextGroups {
                    
                    if childTextGroup.title == collapsedTextGroup.title {
                        
                        collapsingTranslator?.expandTextGroup(string: textStorage, textGroup: childTextGroup)
                        outlineModel?.updateTextGroups(from: textStorage)
                    }
                }
            }
            
            guard let location = textGroup.token?.range.location, let updatedTextGroup = outlineModel?.textGroup(at: location) else {
                
                return
            }
            
            collapsingTranslator?.collapseTextGroup(string: textStorage, updatedTextGroup, outlineModel: outlineModel, collapsedTextGroups: &collapsedTextGroups)
            outlineModel?.updateTextGroups(from: textStorage)
        }
        
        rulerView.needsDisplay = true
        
        ignoreProcessingDelegate.ignoreProcessing(ignore: false)
    }
}
