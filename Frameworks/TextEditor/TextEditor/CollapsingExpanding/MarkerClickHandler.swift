//
//  MarkerClickHandler.swift
//  TextEditor
//
//  Created by charles johnston on 1/23/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

class MarkerClickHandler {
    
    static func markerClicked(_ marker: TextGroupMarker, outlineModel: OutlineModel?, textStorage: NSTextStorage, collapsingTranslator: CollapsingTranslator?, rulerView: TestRulerView, ignoreProcessingDelegate: IgnoreProcessingDelegate) {
        
        guard let collapsingTranslator = collapsingTranslator else {
            return
        }
        
        ignoreProcessingDelegate.ignoreProcessing(ignore: true)
        
        collapsingTranslator.expandAllTextGroups(string: textStorage, outlineModel: outlineModel!)
        
        guard let textGroup = outlineModel?.textGroup(at: marker.token.range.location, collapsedTextGroups: collapsingTranslator.collapsedTextGroups) else {
            print("Error locating textgroup at marker")
            collapsingTranslator.recollapseTextGroups(string: textStorage, outlineModel: outlineModel!, invalidRanges: [])
            ignoreProcessingDelegate.ignoreProcessing(ignore: false)
            return
        }
        
        var textGroupIsCollapsed = false
        
        for collapsedTextGroup in collapsingTranslator.collapsedTextGroups {
            
            if collapsedTextGroup.title == textGroup.title {
                textGroupIsCollapsed = true
                break
            }
        }
        
        if textGroupIsCollapsed {
            
            let indexOfCollapsedTextGroup = collapsingTranslator.collapsedTextGroups.firstIndex { (collapsedTextGroup) -> Bool in
                collapsedTextGroup.title == textGroup.title
            }
            
            if let indexOfCollapsedTextGroup = indexOfCollapsedTextGroup {
                collapsingTranslator.collapsedTextGroups.remove(at: indexOfCollapsedTextGroup)
            }
        }
        else {
            
            collapsingTranslator.collapsedTextGroups.append(textGroup)
        }
        
        collapsingTranslator.recollapseTextGroups(string: textStorage, outlineModel: outlineModel!, invalidRanges: [])
        
        ignoreProcessingDelegate.ignoreProcessing(ignore: false)
    }
}
