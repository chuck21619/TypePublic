//
//  Array+Difference.swift
//  TextEditor
//
//  Created by charles johnston on 9/4/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
