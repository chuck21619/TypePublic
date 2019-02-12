//
//  NSAttributedString+Append.swift
//  TextEditor
//
//  Created by charles johnston on 2/12/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    //MARK: - append
    func appended(_ string: String) -> NSAttributedString {
        
        let attributedString = NSAttributedString(string: string)
        return self.appended(attributedString)
    }
    
    func appended(_ attributedString: NSAttributedString) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.append(attributedString)
        
        return mutableAttributedString
    }
    
    //MARK - prepend
    func prepended(_ string: String) -> NSAttributedString {
        
        let attributedString = NSAttributedString(string: string)
        return self.prepended(attributedString)
    }
    
    func prepended(_ attributedString: NSAttributedString) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.insert(attributedString, at: 0)
        
        return mutableAttributedString
    }
}
