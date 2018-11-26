//
//  TestRulerView.swift
//  TextEditor
//
//  Created by charles johnston on 11/14/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TestRulerView: NSRulerView {
    
    override func mouseDown(with event: NSEvent) {
        
        let invertedY = (self.window?.frame.height ?? 0) - event.locationInWindow.y
        
        for marker in textGroupMarkers {
            
            if invertedY > marker.frame.minY &&
                invertedY < marker.frame.maxY {
                
                self.delegate?.markerClicked(marker)
                break
            }
        }
    }
    
    var textGroupMarkers: [TextGroupMarker] = []
    var visibleTextGroupTokens: [TextGroupToken] = []
    var delegate: TestRulerViewDelegate? = nil
    
    var language: Language? = nil
    
    override init(scrollView: NSScrollView?, orientation: NSRulerView.Orientation) {
        super.init(scrollView: scrollView, orientation: orientation)
        
        scrollView?.verticalRulerView = self
        scrollView?.hasVerticalRuler = true
        scrollView?.rulersVisible = true
        self.ruleThickness = 40
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func drawHashMarksAndLabels(in rect: NSRect) {
//
//        guard let textView = self.clientView as? NSTextView,
//              let layoutManager = textView.layoutManager else {
//            return
//        }
//
//        var newWorkItem: DispatchWorkItem!
//
//        newWorkItem = DispatchWorkItem {
//
//            let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textView.textContainer!)
//            let visibleCharacterNSRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)
//            guard let visibleCharacterRange = Range(visibleCharacterNSRange, in: textView.string) else {
//                return
//            }
//
//            let visibleString = String(textView.string[visibleCharacterRange])
//
//            guard let visibleTextGroupTokens = self.language?.textGroupTokens(for: visibleString, workItem: newWorkItem) else {
//                return
//            }
//        }
//
//
//        DispatchQueue.global(qos: .background).async(execute: newWorkItem)
//    }
    
//    var workItem: DispatchWorkItem? = nil
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        
//        workItem?.cancel()
        self.textGroupMarkers = []
        
        guard let textView = self.clientView as? NSTextView,
              let layoutManager = textView.layoutManager else {
            return
        }
        
        let relativePoint = self.convert(NSZeroPoint, from: textView)
        let lineNumberAttributes = [NSAttributedString.Key.font: textView.font!, NSAttributedString.Key.foregroundColor: NSColor.gray] as [NSAttributedString.Key : Any]
        
        let drawLineNumber = { (lineNumberString:String, y:CGFloat) -> Void in
            let attString = NSAttributedString(string: lineNumberString, attributes: lineNumberAttributes)
            let x = 35 - attString.size().width
            attString.draw(at: NSPoint(x: x, y: relativePoint.y + y))
        }
        
        let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textView.textContainer!)
        
        let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
        
        /// start mine
        let visibleCharacterRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)
        
        guard let visibleTextGroupTokens = self.language?.textGroupTokens(for: textView.string, in: visibleCharacterRange, workItem: nil) else {
            return
        }
        self.visibleTextGroupTokens = visibleTextGroupTokens
        
        let tokenRanges = visibleTextGroupTokens.map { (token) -> NSRange in
            return token.range
        }
        /// end mine
        
        let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])
        // The line number for the first visible line
        var lineNumber = newLineRegex.numberOfMatches(in: textView.string, options: [], range: NSMakeRange(0, firstVisibleGlyphCharacterIndex)) + 1
        
        var glyphIndexForStringLine = visibleGlyphRange.location
        
        // Go through each line in the string.
        while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
            
            // Range of current line in the string.
            let characterRangeForStringLine = (textView.string as NSString).lineRange(
                for: NSMakeRange( layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), 0 )
            )
            let glyphRangeForStringLine = layoutManager.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
            
            var glyphIndexForGlyphLine = glyphIndexForStringLine
            var glyphLineCount = 0
            
            while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
                
                // See if the current line in the string spread across
                // several lines of glyphs
                var effectiveRange = NSMakeRange(0, 0)
                
                // Range of current "line of glyphs". If a line is wrapped,
                // then it will have more than one "line of glyphs"
                let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                
                let charachter = layoutManager.characterRange(forGlyphRange: NSRange(location: glyphIndexForGlyphLine, length: 1), actualGlyphRange: nil)
                
                
                if let intersectedRange = self.intersectedRange(range: charachter, ranges: tokenRanges) {
                    
                    guard let token = visibleTextGroupTokens.first(where: { (token) -> Bool in
                        token.range == intersectedRange
                    }) else {
                        
                        print("ERROR")
                        return
                    }
                    
                    let textGroupMarker = TextGroupMarker(frame: lineRect, token: token)
                    self.textGroupMarkers.append(textGroupMarker)
                    drawLineNumber("GROUP", lineRect.minY)
                }
                else if glyphLineCount > 0 {
                    drawLineNumber("-", lineRect.minY)
                } else {
                    drawLineNumber("\(lineNumber)", lineRect.minY)
                }
                
                // Move to next glyph line
                glyphLineCount += 1
                glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
            }
            
            glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
            lineNumber += 1
        }
        
        // Draw line number for the extra line at the end of the text
        if layoutManager.extraLineFragmentTextContainer != nil {
            drawLineNumber("\(lineNumber)", layoutManager.extraLineFragmentRect.minY)
        }
    }
    
    func intersectedRange(range: NSRange, ranges: [NSRange]) -> NSRange? {
        
        for iteratedRange in ranges {
            
            if iteratedRange.intersects(range) {
                return iteratedRange
            }
        }
        
        return nil
    }
}
