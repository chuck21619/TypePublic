//
//  CollapsingTranslator.swift
//  TextEditor
//
//  Created by charles johnston on 1/21/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

class CollapsingTranslator {
    
    init(delegate: CollapsingTranslatorDelegate, ignoreProcessingDelegate: IgnoreProcessingDelegate) {
        
        self.delegate = delegate
        self.ignoreProcessingDelegate = ignoreProcessingDelegate
    }
    
    var ignoreProcessingDelegate: IgnoreProcessingDelegate
    var delegate: CollapsingTranslatorDelegate
    
//    var invalidRangesSinceLastEditing: [NSRange] = []
//    var editingValuesSinceLastParsing: EditingValues? = nil
    
    func calculateTranslations(string: NSMutableAttributedString, collapsedTextGroups: inout [TextGroup], outlineModel: OutlineModel?, editedRange: NSRange, delta: Int, editingValuesSinceLastProcess: EditingValues?, invalidRangesSinceLastProcess: [NSRange]) -> ((editingValues: EditingValues, invalidRanges: [NSRange])?) {
        
        let translations: (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRanges: [NSRange])
        
        //a non-nil lastEditing var means they have been expanded by a previous processEditing call
        if editingValuesSinceLastProcess == nil {
            
            self.ignoreProcessingDelegate.ignoreProcessing(ignore: true)
            translations = self.expandAllTextGroups(string: string, collapsedTextGroups: collapsedTextGroups, outlineModel: outlineModel, editedRange: editedRange, delta: delta)
            self.ignoreProcessingDelegate.ignoreProcessing(ignore: false)
        }
        else {
            
            let translatedRange = editingValuesSinceLastProcess?.editedRange.union(editedRange) ?? editedRange
            let translatedDelta = delta + (editingValuesSinceLastProcess?.delta ?? 0)
            translations = (adjustedEditedRange: translatedRange, adjustedDelta: translatedDelta, invalidRanges: invalidRangesSinceLastProcess)
        }
        
        guard let editedRange = translations.adjustedEditedRange, let delta = translations.adjustedDelta else {
            return nil
        }
        
        let editingValues = EditingValues(editedRange: editedRange, delta: delta)
        return (editingValues: editingValues, invalidRanges: translations.invalidRanges)
    }
    
    @discardableResult func expandAllTextGroups(string: NSMutableAttributedString, collapsedTextGroups: [TextGroup], outlineModel: OutlineModel?, editedRange: NSRange? = nil, delta: Int? = nil) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRanges: [NSRange]) {
        
        var adjustedEditedRange = editedRange
        var adjustedDelta = delta
        var invalidRanges: [NSRange] = []
        
        var updatedCollapsedTextGroups: [TextGroup] = []
        
        guard let outlineModel = outlineModel else {
            return (adjustedEditedRange: adjustedEditedRange, adjustedDelta: adjustedDelta, invalidRanges: invalidRanges)
        }
        
        for textGroup in outlineModel.parentTextGroup {
            
            for collapsedTextGroup in collapsedTextGroups {
                
                if textGroup.title == collapsedTextGroup.title {
                    updatedCollapsedTextGroups.append(textGroup)
                }
            }
        }
        
        let sortedCollapsedTextGroups = updatedCollapsedTextGroups.sorted { (firstTextGroup, secondTextGroup) -> Bool in
            return firstTextGroup.token?.range.location ?? 0 < secondTextGroup.token?.range.location ?? 0
        }
        
        for collapsedTextGroup in sortedCollapsedTextGroups {
            
            if let collapsedTextGroupsParentTextGroup = collapsedTextGroup.parentTextGroup, collapsedTextGroups.contains(collapsedTextGroupsParentTextGroup) == true {
                
                continue
            }
            
            let adjustments = expandTextGroup(string: string, textGroup: collapsedTextGroup, invalidateDisplay: false, editedRange: adjustedEditedRange, delta: adjustedDelta, outlineModel: outlineModel)
            
            adjustedEditedRange = adjustments.adjustedEditedRange
            adjustedDelta = adjustments.adjustedDelta
            
            if let invalidRange = adjustments.invalidRange {
                invalidRanges.append(invalidRange)
            }
        }
        
        return (adjustedEditedRange: adjustedEditedRange, adjustedDelta: adjustedDelta, invalidRanges: invalidRanges)
    }
    
    @discardableResult func expandTextGroup(string: NSMutableAttributedString, textGroup: TextGroup, invalidateDisplay: Bool = true, editedRange: NSRange? = nil, delta: Int? = nil, outlineModel: OutlineModel?) -> (adjustedEditedRange: NSRange?, adjustedDelta: Int?, invalidRange: NSRange?) {
        
        //get the textattachment
        guard let token = textGroup.token else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        
        let attributeLocation = (token.range.location + token.range.length)
        let attributeRange = NSRange(location: attributeLocation, length: 1)
        guard let attachment = string.attribute(.attachment, at: attributeLocation, effectiveRange: nil) as? TestTextAttachment else {
            return (adjustedEditedRange: nil, adjustedDelta: nil, invalidRange: nil)
        }
        
        let stringInAttachment = attachment.myString
        
        let replacingRange = NSRange(location: attributeRange.location, length: attributeRange.length)
        string.replaceCharacters(in: replacingRange, with: stringInAttachment)
        //outlineModel?.reCalculateTextGroups(replacingRange: replacingRange, with: stringInAttachment.string, expandingTextGroup: textGroup, downwardDraggingGroup: nil)
        
        let invalidRange = NSRange(location: attributeRange.location, length: stringInAttachment.string.maxNSRange.length)
        
        if invalidateDisplay {
            self.delegate.invalidateRanges(invalidRanges: [invalidRange])
        }
        
        var invalidRangeReturnValue: NSRange? = nil
        var deltaReturnValue = delta
        var editedRangeReturnValue = editedRange
        
        if editedRange?.intersection(attributeRange)?.length ?? 0 > 0 {
            
            if let delta = delta {
                deltaReturnValue = (delta - stringInAttachment.string.maxNSRange.length) + 1 //+1 due to the textAttachment
            }
            
            if let editedRange = editedRange {
                let location = editedRange.location
                let length = editedRange.length + stringInAttachment.string.maxNSRange.length - 1 //-1 due to the textAttachment
                editedRangeReturnValue = NSRange(location: location, length: length)
            }
        }
        else if editedRange?.location ?? 0 > attributeRange.location, let editedRange = editedRange {
            
            let location = editedRange.location + stringInAttachment.string.maxNSRange.length - 1 //-1 due to textAttachment
            let length = editedRange.length
            editedRangeReturnValue = NSRange(location: location, length: length)
        }
        
        if editedRange?.intersects(attributeRange) == true {
            invalidRangeReturnValue = invalidRange
        }
        
        return (adjustedEditedRange: editedRangeReturnValue, adjustedDelta: deltaReturnValue, invalidRange: invalidRangeReturnValue)
    }
    
    @discardableResult func recollapseTextGroups(string: NSMutableAttributedString, outlineModel: OutlineModel?, invalidRanges: [NSRange], collapsedTextGroups: [TextGroup]) -> [NSRange] {
        
        var adjustedInvalidRanges = invalidRanges
        var collapsedTextGroups = collapsedTextGroups
        var deltaFromPreviousCollapses = 0
        
        let expandedString = NSMutableAttributedString(attributedString: string)
        
        //TODO: consolidate textgroups. so not every method/class/instance/etc has to go and grab the updated ones
        //TODO: consolidate textgroups
        //TODO: consolidate textgroups
        // this is going to be a significant improvement to the design
        var updatedCollapsedTextGroups: [TextGroup] = []
        guard let outlineModel = outlineModel else {
            return adjustedInvalidRanges
        }
        for textGroup in outlineModel.parentTextGroup {
            
            for collapsedTextGroup in collapsedTextGroups {
                
                if textGroup.title == collapsedTextGroup.title {
                    updatedCollapsedTextGroups.append(textGroup)
                }
            }
        }
        
        let sortedCollapsedTextGroups = updatedCollapsedTextGroups.sorted { (firstTextGroup, secondTextGroup) -> Bool in
            return firstTextGroup.token?.range.location ?? 0 < secondTextGroup.token?.range.location ?? 0
        }
        
        for collapsedTextGroup in sortedCollapsedTextGroups {
            
            var correspondingTextGroup: TextGroup! = nil
            
            for iteratedTextGroup in outlineModel.parentTextGroup {
                
                if iteratedTextGroup.title == collapsedTextGroup.title {
                    correspondingTextGroup = iteratedTextGroup
                    
                    if correspondingTextGroup != collapsedTextGroup {
                        print("ERROR - revert to using corresponding textgroup")
                        //TODO: find other places where i am finding the corresponding text group and test if they are still necessasary
                    }
                    break
                }
            }
            
            guard correspondingTextGroup != nil else {
                continue
            }
            
            if let collapsedTextGroupsParentTextGroup = correspondingTextGroup.parentTextGroup, collapsedTextGroups.contains(collapsedTextGroupsParentTextGroup) == true {
                continue
            }
            
            //TODO: optimize
            var skip = false
            for collapsedTextGroup in collapsedTextGroups {
                
                if correspondingTextGroup.parentTextGroup?.title ?? "" == collapsedTextGroup.title {
                    skip = true
                    break
                }
            }
            
            guard skip == false else {
                continue
            }
            
            let changes = self.collapseTextGroup(string: string, correspondingTextGroup, invalidRanges: invalidRanges, outlineModel: outlineModel, collapsedTextGroups: &collapsedTextGroups, recollapsing: true, adjustForDelta: deltaFromPreviousCollapses, expandedString: expandedString)
            adjustedInvalidRanges = changes.adjustedInvalidRanges
            deltaFromPreviousCollapses += changes.delta
            deltaFromPreviousCollapses -= 1
        }
        
        return adjustedInvalidRanges
    }
    
    @discardableResult func collapseTextGroup(string: NSMutableAttributedString, _ textGroup: TextGroup, invalidRanges: [NSRange] = [], outlineModel: OutlineModel?, collapsedTextGroups: inout [TextGroup], recollapsing: Bool = false, adjustForDelta: Int, expandedString: NSMutableAttributedString) -> (adjustedInvalidRanges: [NSRange], delta: Int) {
        
//        outlineModel?.updateTextGroups(from: string)
        
        var correspondingTextGroup: TextGroup? = nil
        
        guard let parentTextGroup = outlineModel?.parentTextGroup else {
            return (adjustedInvalidRanges: [], delta: 0)
        }
        
        correspondingTextGroup = textGroup
        for iteratedTextGroup in parentTextGroup {
            
            if iteratedTextGroup.title == textGroup.title {
                correspondingTextGroup = iteratedTextGroup
                
                if correspondingTextGroup != textGroup {
                    print("ERROR - revert to using corresponding textgroup")
                    //TODO: find other places where i am finding the corresponding text group and test if they are still necessasary
                }
                break
            }
        }
        
        guard correspondingTextGroup != nil else {
            return (adjustedInvalidRanges: [], delta: 0)
        }
        
        var range: NSRange
        if recollapsing {
            range = outlineModel!.range(of: correspondingTextGroup!, in: expandedString, includeTitle: false)!
        }
        else {
            range = collapsedTextGroupRange(string: expandedString, outlineModel: outlineModel, correspondingTextGroup!)!
        }
        
        range = NSRange(location: range.location - adjustForDelta, length: range.length)
        
        let location = range.location
        let endIndex = (location + range.length)
        
        let textGroupString = string.attributedSubstring(from: range)
        let attachment = TestTextAttachment(data: nil, ofType: "someType")
        attachment.image = #imageLiteral(resourceName: "elipses")
        attachment.bounds = NSRect(x: 1, y: -1, width: 15, height: 10)
        
        attachment.myString = textGroupString
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        let replacingRange = NSRange(location: location, length: endIndex-location)
        string.replaceCharacters(in: replacingRange, with: attachmentString)
        //outlineModel?.reCalculateTextGroups(replacingRange: replacingRange, with: attachmentString.string, expandingTextGroup: nil, downwardDraggingGroup: nil)
        
        var collapsedGroupRangeNeedsToBeInvalidated = false
        for invalidRange in invalidRanges {
            if invalidRange.intersects(range) {
                collapsedGroupRangeNeedsToBeInvalidated = true
                break
            }
        }
        
        var adjustedInvalidRanges: [NSRange] = []
        for invalidRange in invalidRanges {
            
            var adjustedRange: NSRange? = nil
            let groupRange = range
            
            let invalidStartIndex = invalidRange.location
            let invalidEndIndex = invalidRange.location + invalidRange.length
            let groupStartIndex = groupRange.location
            let groupEndIndex = groupRange.location + groupRange.length
            
            //1
            if invalidStartIndex <= groupStartIndex && invalidEndIndex >= groupEndIndex {
                adjustedRange = NSRange(location: invalidRange.location, length: invalidRange.length - groupRange.length)
            }
            //2
            else if invalidEndIndex <= groupStartIndex {
                adjustedRange = invalidRange
            }
            //3
            else if invalidStartIndex >= groupEndIndex {
                adjustedRange = NSRange(location: invalidRange.location - groupRange.length, length: invalidRange.length)
            }
            //4
            else if invalidStartIndex <= groupStartIndex && invalidEndIndex > groupStartIndex && invalidEndIndex < groupEndIndex {
                guard let overlap = invalidRange.intersection(groupRange)?.length else {
                    continue
                }
                
                adjustedRange = NSRange(location: invalidRange.location, length: invalidRange.length - overlap)
            }
            //5
            else if invalidStartIndex > groupStartIndex && invalidStartIndex < groupEndIndex && invalidEndIndex > groupEndIndex {
                guard let overlap = invalidRange.intersection(groupRange)?.length else {
                    continue
                }
                
                adjustedRange = NSRange(location: invalidRange.location - overlap, length: invalidRange.length - overlap)
            }
            //6
            else if invalidStartIndex >= groupStartIndex && invalidEndIndex <= groupEndIndex {
                adjustedRange = nil
            }
            
            if let adjustedRange = adjustedRange {
                adjustedInvalidRanges.append(adjustedRange)
            }
        }
        
        if collapsedGroupRangeNeedsToBeInvalidated {
            adjustedInvalidRanges.append(range)
        }
        
        var alreadyInArray = false
        for collapsedTextGroup in collapsedTextGroups {
            
            if collapsedTextGroup.hasSameChildrenTitles(as: textGroup) {
                
                alreadyInArray = true
            }
        }
        
        if !alreadyInArray {
            
            collapsedTextGroups.append(textGroup)
        }
        
        return (adjustedInvalidRanges: adjustedInvalidRanges, delta: range.length)
    }
    
    private func collapsedTextGroupRange(string: NSMutableAttributedString, outlineModel: OutlineModel?, _ textGroup: TextGroup) -> NSRange? {
        
        var correspondingTextGroup: TextGroup? = nil
        
        guard let parentTextGroup = textGroup.parentTextGroup else {
            return nil
        }
        
        for iteratedTextGroup in parentTextGroup {
            
            if iteratedTextGroup.title == textGroup.title {
                correspondingTextGroup = iteratedTextGroup
                break
            }
        }
        
        guard let locationOfToken = correspondingTextGroup?.token?.range.location,
            let lengthOfToken = correspondingTextGroup?.token?.range.length else {
                return nil
        }
        
        let location = locationOfToken + lengthOfToken
        
        let endIndex: Int
        // get next text group that is not a child,
        if let nextTextGroup = outlineModel?.nextTextGroupWithEqualOrHigherPriority(after: textGroup),
            let token = nextTextGroup.token {
            
            endIndex = token.range.location - 1
        }
        // if no next text group, then use end of string
        else {
            
            endIndex = string.string.maxNSRange.length
        }
        
        let range = NSRange(location: location, length: endIndex-location)
        
        return range
    }
}
