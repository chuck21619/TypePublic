//
//  TestOutlineDragNDropTextGroups.swift
//  TextEditorTests
//
//  Created by charles johnston on 4/3/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import XCTest
@testable import TextEditor

class TestOutlineDragNDropTextGroups: XCTestCase, TextEditorViewControllerDelegate {
    
    let demoString = "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group\ntext inside the second group\n\n## nested second group\ntext insdie the nested second group"
    
    func testDragTopGroupDownOne() {
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        
        let firstTextGroup = viewController!.outlineModel!.parentTextGroup.textGroups[0]
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, pasteboardWriterForItem: firstTextGroup as Any)
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, acceptDrop: StubDraggingInfo(), item: nil, childIndex: 2)
        
        XCTAssert(viewController?.textStorage.string == "\n# second group\ntext inside the second group\n\n## nested second group\ntext insdie the nested second group\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n")
    }
    
    func testDragBottomGroupUpOne() {
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        
        let secondTextGroup = viewController!.outlineModel!.parentTextGroup.textGroups[1]
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, pasteboardWriterForItem: secondTextGroup as Any)
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, acceptDrop: StubDraggingInfo(), item: nil, childIndex: 0)
        
        XCTAssert(viewController?.textStorage.string == "\n# second group\ntext inside the second group\n\n## nested second group\ntext insdie the nested second group\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n")
    }
    
    func testDragCollapsedGroupDownOneThenExpand() {
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        guard let marker = viewController?.rulerView.textGroupMarkers[1] else {
            XCTFail()
            return
        }
        viewController?.markerClicked(marker)
        
        //not the best validation here. this is to check that the text group collapsed
        XCTAssert(viewController!.textStorage.string.count < demoString.count)
        
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        let parentTextGroup = viewController!.outlineModel!.parentTextGroup.textGroups[0]
        let collapsedTextGroup = parentTextGroup.textGroups[0]
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, pasteboardWriterForItem: collapsedTextGroup as Any)
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, acceptDrop: StubDraggingInfo(), item: parentTextGroup as Any, childIndex: 2)
        
        viewController?.collapsingTranslator?.expandAllTextGroups(string: viewController!.textStorage, outlineModel: viewController!.outlineModel!)
        
        XCTAssert(viewController!.textStorage.string == "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group\ntext inside the second group\n\n## nested second group\ntext insdie the nested second group")
        
    }
    
    func testDragCollapsedGroupIntoADifferentParentGroupThenExpand() {
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        guard let marker = viewController?.rulerView.textGroupMarkers[1] else {
            XCTFail()
            return
        }
        viewController?.markerClicked(marker)
        
        //not the best validation here. this is to check that the text group collapsed
        XCTAssert(viewController!.textStorage.string.count < demoString.count)
        
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        let collapsedTextGroup = viewController!.outlineModel!.parentTextGroup.textGroups[0].textGroups[0]
        let targetParentTextGroup = viewController!.outlineModel?.parentTextGroup.textGroups[1]
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, pasteboardWriterForItem: collapsedTextGroup as Any)
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, acceptDrop: StubDraggingInfo(), item: targetParentTextGroup as Any, childIndex: 0)
        
        viewController?.collapsingTranslator?.expandAllTextGroups(string: viewController!.textStorage, outlineModel: viewController!.outlineModel!)
        
        XCTAssert(viewController!.textStorage.string == "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group\ntext inside the second group\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## nested second group\ntext insdie the nested second group")
    }
    
    func testDragCollapsedGroupIntoCollapsedGroupThenExpand() {
        
        let documentOpener = DocumentOpener(demoString: demoString)
        let viewController = TextEditorViewController.createInstance(delegate: self, documentOpener: documentOpener)
        viewController?.loadView()
        viewController?.viewDidLoad()
        viewController?.outlineViewController?.loadView()
        viewController?.outlineViewController?.viewDidLoad()
        
        viewController?.outlineModel?.outline(textStorage: viewController!.textStorage)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        guard let markerForDraggingGroup = viewController?.rulerView.textGroupMarkers[1] else {
            XCTFail()
            return
        }
        viewController?.markerClicked(markerForDraggingGroup)
        
        //not the best validation here. this is to check that the text group collapsed
        XCTAssert(viewController!.textStorage.string.count < demoString.count)

        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        let stringCountAfterFirstCollapse = viewController!.textStorage.string.count
        
        guard let markerForTargetParentGroup = viewController?.rulerView.textGroupMarkers[5] else {
            XCTFail()
            return
        }
        
        viewController?.markerClicked(markerForTargetParentGroup)
        viewController?.rulerView.drawHashMarksAndLabels(in: NSRect(x: 0, y: 0, width: 5000, height: 5000))
        
        //not the best validation here. this is to check that the second text group collapsed
        XCTAssert(viewController!.textStorage.string.count < stringCountAfterFirstCollapse)
        
        let draggingGroup = viewController!.outlineModel!.parentTextGroup.textGroups[0].textGroups[0]
        let targetParentTextGroup = viewController!.outlineModel!.parentTextGroup.textGroups[1]
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, pasteboardWriterForItem: draggingGroup as Any)
        let _ = viewController?.outlineViewController?.outlineView(viewController!.outlineViewController!.outlineView, acceptDrop: StubDraggingInfo(), item: targetParentTextGroup as Any, childIndex: 0)
        
        //validate the text groups after moving
        XCTAssert(NSString(string: viewController!.textStorage.string) == NSString(string: "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group￼") )
        
        //validate the expanded string
        viewController?.collapsingTranslator?.expandAllTextGroups(string: viewController!.textStorage, outlineModel: viewController!.outlineModel!)
        
        XCTAssert(viewController!.textStorage.string == "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group\ntext inside the second group\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## nested second group\ntext insdie the nested second group")
    }
    
    //MARK: - TextEditorViewControllerDelegate
    func presentSideboard(viewController: NSViewController) {
        //
    }
}
