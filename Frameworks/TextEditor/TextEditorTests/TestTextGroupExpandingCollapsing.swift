//
//  TestTextGroupExpandingCollapsing.swift
//  TextEditorTests
//
//  Created by charles johnston on 4/1/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import XCTest
@testable import TextEditor

class TestTextGroupExpandingCollapsing: XCTestCase, TextEditorViewControllerDelegate {
    
    func testSingleGroupCollapseThenExpand() {
        
        let demoString = "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n"
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "outline the document")
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
            
            XCTAssertTrue(viewController?.rulerView.textGroupMarkers.count == 1)
            
            guard let marker = viewController?.rulerView.textGroupMarkers[0] else {
                XCTFail()
                return
            }
            
            DispatchQueue.main.async {
                viewController?.markerClicked(marker)
                
                XCTAssert(viewController?.textStorage.string.count == 12)
                
                
                let attributedString = NSAttributedString(attributedString: viewController!.textStorage)
                var range = attributedString.string.maxNSRange
                range = NSRange(location: range.location, length: range.length - 1)
                let substring = attributedString.attributedSubstring(from: range)
                
                XCTAssert(substring.string == "\n# creation")
                
                viewController?.markerClicked(marker)
                
                XCTAssert(viewController?.textStorage.string == demoString)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 16.0)
    }
    
    func testCollapseNestedGroups() {
        
        let demoString = "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n"
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "outline the document")
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
            
            XCTAssertTrue(viewController?.rulerView.textGroupMarkers.count == 2)
            
            guard let childMarker = viewController?.rulerView.textGroupMarkers[1],
                  let parentMarker = viewController?.rulerView.textGroupMarkers[0] else {
                XCTFail()
                return
            }
            
            DispatchQueue.main.async {
                
                //collapse child and check string
                viewController?.markerClicked(childMarker)
                
                XCTAssert(viewController?.textStorage.string.count == 102)
                
                let attributedString = NSAttributedString(attributedString: viewController!.textStorage)
                var range = attributedString.string.maxNSRange
                range = NSRange(location: range.location, length: range.length - 1)
                let substring = attributedString.attributedSubstring(from: range)
                
                XCTAssert(substring.string == "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression")
                
                
                //collapse parent and check string
                viewController?.markerClicked(parentMarker)
                
                let attributedString2 = NSAttributedString(attributedString: viewController!.textStorage)
                var range2 = attributedString2.string.maxNSRange
                range2 = NSRange(location: range2.location, length: range2.length - 1)
                let substring2 = attributedString.attributedSubstring(from: range2)
                
                XCTAssert(substring2.string == "\n# creation")
                
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 16.0)
    }
    
    //MARK: - TextEditorViewControllerDelegate
    func presentSideboard(viewController: NSViewController) {
        //
    }
}
