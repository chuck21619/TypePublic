//
//  AttributeOccurrencesProvider.swift
//  TextEditor
//
//  Created by charles johnston on 8/27/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

protocol AttributeOccurrencesProvider {
    
    func attributes(for keyword: Keyword, in string: String, workItem: DispatchWorkItem) -> [AttributeOccurrence]
}
