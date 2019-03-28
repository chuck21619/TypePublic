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
        
        collapsingTranslator?.expandAllTextGroups(string: textStorage, collapsedTextGroups: collapsedTextGroups, outlineModel: outlineModel!)
        
        guard let textGroup = outlineModel?.textGroup(at: marker.token.range.location, collapsedTextGroups: &collapsedTextGroups) else {
            print("Error locating textgroup at marker")
            collapsingTranslator?.recollapseTextGroups(string: textStorage, outlineModel: outlineModel!, invalidRanges: [], collapsedTextGroups: collapsedTextGroups)
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
            
//            collapsingTranslator?.expandTextGroup(string: textStorage, textGroup: textGroup, outlineModel: outlineModel)
            
            let indexOfCollapsedTextGroup = collapsedTextGroups.firstIndex { (collapsedTextGroup) -> Bool in
                collapsedTextGroup.title == textGroup.title
            }
            
            if let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup {
                collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            }
        }
        else {
            
            collapsedTextGroups.append(textGroup)
        }
        
        collapsingTranslator?.recollapseTextGroups(string: textStorage, outlineModel: outlineModel!, invalidRanges: [], collapsedTextGroups: collapsedTextGroups)
        
        ignoreProcessingDelegate.ignoreProcessing(ignore: false)
    }
}
