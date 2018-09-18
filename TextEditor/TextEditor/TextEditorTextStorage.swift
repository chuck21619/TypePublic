//
//  TextEditorTextStorage.swift
//  TextEditor
//
//  Created by charles johnston on 7/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol TextStorageDelegate {
    
    func didChangeAttributeOccurrences(changedAttributeOccurrences: [AttributeOccurrence])
    func invalidateRanges(invalidRanges: [NSRange])
}

class TextEditorTextStorage: NSTextStorage {

//    let backingStore = NSMutableAttributedString()
    let backingStore = NSTextStorage()
    let syntaxParser = SyntaxParser()
    
    // TODO: rename delegate
    var myDelegate: TextStorageDelegate? = nil
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {

        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    // mandatory overrides to use our backingStore.string
    var lastEditedRange: NSRange = NSRange(location: 0, length: 0)
    var lastChangeInLength: Int = 0
    override func replaceCharacters(in range: NSRange, with str: String) {
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        lastEditedRange = editedRange
        lastChangeInLength = changeInLength
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
        
//        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
//        endEditing()
    }
    
    // methods to apply attributes
    // TODO: cleanup (now there is previousEditedRange and lastEditedRange - that is friggen terrible)
    // TODO: cleanup (now there is previousChangeInLength and lastChangeInLength - that is friggen terrible)
    var previousEditedRange: NSRange? = nil
    var previousChangeInLength: Int? = nil
    func applyStylesToRange(searchRange: NSRange) {
        
        if let previousEditedRange = self.previousEditedRange {
            
            self.previousEditedRange = previousEditedRange.union(self.lastEditedRange)
        }
        else {
            
            self.previousEditedRange = self.lastEditedRange
        }
        
        if let previousChangeInLength = self.previousChangeInLength {
            
            self.previousChangeInLength = previousChangeInLength + self.lastChangeInLength
        }
        else {
            
            self.previousChangeInLength = self.lastChangeInLength
        }
        
        DispatchQueue.global().async {
        
            // TODO: remove force unwrapping - it is being used for testing
            let editedRange = self.previousEditedRange!// ?? self.lastEditedRange
            let changeInLength = self.previousChangeInLength!// ?? self.lastChangeInLength
            
            // get attributes from syntax parser
            guard let attributeOccurrences = self.syntaxParser.attributeOccurrences(for: self.backingStore.string, range: searchRange, editedRange: editedRange, changeInLength: changeInLength) else {
                return
            }
            let newAttributeOccurrences = attributeOccurrences.newAttributeOccurrences
            let invalidAttributeRanges = attributeOccurrences.invalidRanges
            let allAttributeOccurrences = attributeOccurrences.allAttributeOccurrences
            
            
            let normalColorAttribute = Attribute(key: .foregroundColor, value: NSColor.black)
            //TODO: get font from settings
            let normalFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
            let normalFontAttribute = Attribute(key: .font, value: normalFont)
            
            guard self.backingStore.string.maxNSRange == searchRange else {
                
                /*
                 problem:
                    if the characters are replaced quickly, then this guard condition (self.backingStore.string.maxNSRange == searchRange) will be true which means it is invalid (the string can change but still have the same length). need to find a correct way of checking vailidity
                 
                 possible solution:
                    use dispatchWorkItem
                    call cancel all on previous workItems at the beginning of each pass
                 */
                
                /*
                 problem:
                    when the newest pass completes. it ignores invalidation that should have occurred on previous passes
                 
                 possible solution:
                    save the (editedRange, changeInLength) before entering background queue
                    include all saved (editedRange, changeInLength) values when calling syntaxParser
                    set (editedRange, changeInLength) to nil on a successful pass
                 
                    problem:
                        the union of editedRanges may include unchanged ranges
                 
                    solution:
                        change the syntaxParser method to accept an array of ranges
                        in the syntaxParser
                            make the current method private, and add a new method with the same signature except that ranges will be an array
                            if the ranges do not intersect, call the private method with each range and append together in the response
                            if the ranges do intersect, call the private method with the range.union and return that response
                 
                    potential problem:
                        will the changeInLength be valid when adding to the new pass?
                 */
                
                /*
                 optimization:
                    enable abandonment during syntaxParsing
                 
                 possible solution:
                    i believe the workItem must be passed around to whoever wants to cancel it (the syntaxParser.attriubtes method and in-turn the language.attributes method)
                 */
                
                // additionally: could add a failsafe to process every 10 seconds or so
                
                
                
                print("CHECK IT")
                return
            }
            
            self.previousEditedRange = nil
            self.previousChangeInLength = nil
            
            //TODO: figure out a good way to do this
            //the reason it was moved it here: when the pass is abandoned, syntax parser still sets the lastAttributes - so when the next successful pass happens, it is basing it's algorithm on invalid data becuase the lastAttributes is used to calcuated what needs to be updated
            self.syntaxParser.lastAttributeOccurrences = allAttributeOccurrences
            
            DispatchQueue.main.async {
        
                // invalidating must happen first and new attributes may include the invalid ranges
                //TODO: consolidate invalid and new attributes
                for invalidAttributeRange in invalidAttributeRanges {
                    
                    self.backingStore.addAttribute(normalColorAttribute.key, value: normalColorAttribute.value, range: invalidAttributeRange)
                    self.backingStore.addAttribute(normalFontAttribute.key, value: normalFontAttribute.value, range: invalidAttributeRange)
                }
                
                for attributeOccurence in newAttributeOccurrences {
                    
                    self.backingStore.addAttribute(attributeOccurence.attribute.key, value: attributeOccurence.attribute.value, range: attributeOccurence.attributeRange)
                }
                
                let newAttributesRanges = newAttributeOccurrences.map({ (attributeOccurence) -> NSRange in
                    return attributeOccurence.effectiveRange
                })
                
                self.myDelegate?.invalidateRanges(invalidRanges: invalidAttributeRanges)
                self.myDelegate?.invalidateRanges(invalidRanges: newAttributesRanges)
            }
        }
    }
    
    func rangeToPerformAttributeReplacements(editedRange: NSRange) -> NSRange {
        
        //range for all text
        return backingStore.string.maxNSRange
        
        //range for only edited line
//        var extendedRange = NSUnionRange(editedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(editedRange.location, 0)))
//        extendedRange = NSUnionRange(editedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(editedRange), 0)))
//
//        return extendedRange
    }
    
    func updateAllAttributeOccurrences() {

        let rangeToApplyAttributes = rangeToPerformAttributeReplacements(editedRange: editedRange)
        applyStylesToRange(searchRange: rangeToApplyAttributes)
    }
    
    override func processEditing() {

        super.processEditing()
        updateAllAttributeOccurrences()
    }
}
