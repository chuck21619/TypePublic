//
//  TextGroupTests.swift
//  TextEditorTests
//
//  Created by charles johnston on 10/26/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import XCTest
@testable import TextEditor

class TextGroupTests: XCTestCase {
    
    func testPrinting() {
        
        let textGroup = createSampleTextGroup()
        
        print("\n")
        print(textGroup)
        print("\n")
    }
    
    // sample text groups
    //
    // 1
    // 2
    //   2.1
    //   2.2
    //     2.2.1
    //   2.3
    // 3
    //   3.1
    //   3.2
    // 4
    // 5
    //
    private func createSampleTextGroup() -> TextGroup {

        let language = MarkdownFactory().createMarkdown()
        let rules = language.textGroupingRules
        
        let parentTokenRange = NSRange(location: 0, length: 0)
        let parentToken = TextGroupToken(label: "", range: parentTokenRange, groupingRule: rules[0])
        let parentTextGroup = TextGroup(title: "parent", token: parentToken)
        
        let firstTokenRange = NSRange(location: 0, length: 1)
        let firstToken = TextGroupToken(label: "1", range: firstTokenRange, groupingRule: rules[1])
        let one = TextGroup(title: firstToken.label, token: firstToken)
        parentTextGroup.textGroups.append(one)
        
        let secondTokenRange = NSRange(location: 1, length: 1)
        let secondToken = TextGroupToken(label: "2", range: secondTokenRange, groupingRule: rules[0])
        let two = TextGroup(title: secondToken.label, token: secondToken)
        parentTextGroup.textGroups.append(two)
        
        let thirdTokenRange = NSRange(location: 2, length: 1)
        let thirdToken = TextGroupToken(label: "2.1", range: thirdTokenRange, groupingRule: rules[1])
        let two_one = TextGroup(title: thirdToken.label, token: thirdToken)
        two.textGroups.append(two_one)
        
        let fourthTokenRange = NSRange(location: 3, length: 1)
        let fourthToken = TextGroupToken(label: "2.2", range: fourthTokenRange, groupingRule: rules[1])
        let two_two = TextGroup(title: fourthToken.label, token: fourthToken)
        two.textGroups.append(two_two)
        
        let fifthTokenRange = NSRange(location: 4, length: 1)
        let fifthToken = TextGroupToken(label: "2.2.1", range: fifthTokenRange, groupingRule: rules[2])
        let two_two_one = TextGroup(title: fifthToken.label, token: fifthToken)
        two_two.textGroups.append(two_two_one)
        
        let sixthTokenRange = NSRange(location: 5, length: 1)
        let sixthToken = TextGroupToken(label: "2.3", range: sixthTokenRange, groupingRule: rules[1])
        let two_three = TextGroup(title: sixthToken.label, token: sixthToken)
        two.textGroups.append(two_three)
        
        let seventhTokenRange = NSRange(location: 6, length: 1)
        let seventhToken = TextGroupToken(label: "3", range: seventhTokenRange, groupingRule: rules[0])
        let three = TextGroup(title: seventhToken.label, token: seventhToken)
        parentTextGroup.textGroups.append(three)
        
        let eighthTokenRange = NSRange(location: 7, length: 1)
        let eighthToken = TextGroupToken(label: "3.1", range: eighthTokenRange, groupingRule: rules[2])
        let three_one = TextGroup(title: eighthToken.label, token: eighthToken)
        three.textGroups.append(three_one)
        
        let ninthTokenRange = NSRange(location: 8, length: 1)
        let ninthToken = TextGroupToken(label: "3.2", range: ninthTokenRange, groupingRule: rules[1])
        let three_two = TextGroup(title: ninthToken.label, token: ninthToken)
        three.textGroups.append(three_two)
        
        let tenthTokenRange = NSRange(location: 9, length: 1)
        let tenthToken = TextGroupToken(label: "4", range: tenthTokenRange, groupingRule: rules[0])
        let four = TextGroup(title: tenthToken.label, token: tenthToken)
        parentTextGroup.textGroups.append(four)
        
        let eleventhTokenRange = NSRange(location: 10, length: 1)
        let eleventhToken = TextGroupToken(label: "5", range: eleventhTokenRange, groupingRule: rules[0])
        let five = TextGroup(title: eleventhToken.label, token: eleventhToken)
        parentTextGroup.textGroups.append(five)
        
        return parentTextGroup
    }
}
