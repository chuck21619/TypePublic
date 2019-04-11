//
//  TextGroup.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroup: NSObject, NSCoding, NSPasteboardWriting, NSPasteboardReading {
    
    // MARK: - Properties
    let title: String
    let token: TextGroupToken?
    static let pasteboardType = NSPasteboard.PasteboardType(rawValue: "\(Bundle.main.bundleIdentifier ?? "Type").textGroup")
    weak var parentTextGroup: TextGroup? = nil
    var textGroups: [TextGroup] = [] {
        
        didSet {
            
            for textGroup in textGroups {
                
                textGroup.parentTextGroup = self
            }
        }
    }
    
    // MARK: - Methods
    // MARK: Constructor
    init(title: String, textGroups: [TextGroup] = [], token: TextGroupToken? = nil) {
        
        defer {
            //causes didSet to be called
            self.textGroups = textGroups
        }
        
        self.title = title
        self.token = token
        
        super.init()
    }
    
    // MARK: etc.
    // TODO: validate this method
    func isDescendant(of parent: TextGroup) -> Bool {
        
        if self.parentTextGroup == parent {
            return true
        }
        
        guard let myParentTextGroup = self.parentTextGroup else {
            return false
        }
    
        return myParentTextGroup.isDescendant(of: parent)
        
    }
    
    // MARK: - Description
    override var description: String {

        func updateIndention(textGroup: TextGroup, lastTextGroup: TextGroup?, indentLevel: Int) -> Int {
            
            if lastTextGroup == nil {
                
                return indentLevel
            }
            else if lastTextGroup?.parentTextGroup?.textGroups.contains(textGroup) == true {
                
                return indentLevel
            }
            else if lastTextGroup?.textGroups.contains(textGroup) == true {
                
                return indentLevel + 1
            }
            else {
                
                return updateIndention(textGroup: textGroup, lastTextGroup: lastTextGroup?.parentTextGroup, indentLevel: indentLevel - 1)
            }
        }
        
        var string = ""
        
        var lastTextGroup: TextGroup? = nil
        
        var indentLevel = 0
        
        for textGroup in self {
            
            indentLevel = updateIndention(textGroup: textGroup, lastTextGroup: lastTextGroup, indentLevel: indentLevel)

            for _ in 0..<indentLevel {

                string = "\(string)    "
            }
            string = "\(string)\(textGroup.title) : \(textGroup.token?.range ?? NSRange(location: 0, length: 0))\n"


            lastTextGroup = textGroup
        }
        
        return string
    }
    
    // MARK: - Equatable
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let rhs = object as? TextGroup else {
            return false
        }
        
        let lhs = self
        
        let isEqual = lhs.title == rhs.title &&
            lhs.textGroups == rhs.textGroups &&
            lhs.token == rhs.token
        
        return isEqual
    }
    
    // MARK: NSPasteboardWriting/NSPasteboardReading
    //This method is considered optional because, if readableTypes(for:) returns just a single type, and that type uses the asKeyedArchive reading option, then instances are initialized using init(coder:) instead of this method.
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        
        return nil
    }
    
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        
        return [TextGroup.pasteboardType]
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        
        return [TextGroup.pasteboardType]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        
        guard type == TextGroup.pasteboardType else {
            
            return nil
        }
        
        return NSKeyedArchiver.archivedData(withRootObject:self)
    }
    
    // MARK: - NSCoding
    let titleCodingKey = "title"
    let tokenCodingKey = "tokenCodingKey"
    let parentTextGroupCodingKey = "parentTextGroupCodingKey"
    let textGroupsCodingKey = "textGroupsCodingKey"
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(title, forKey: titleCodingKey)
        aCoder.encode(token, forKey: tokenCodingKey)
        aCoder.encode(parentTextGroup, forKey: parentTextGroupCodingKey)
        aCoder.encode(textGroups, forKey: textGroupsCodingKey)
    }

    required init?(coder aDecoder: NSCoder) {

        self.title = aDecoder.decodeObject(forKey: titleCodingKey) as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: tokenCodingKey) as? TextGroupToken
        self.parentTextGroup = aDecoder.decodeObject(forKey: parentTextGroupCodingKey) as? TextGroup
        self.textGroups = aDecoder.decodeObject(forKey: textGroupsCodingKey) as? [TextGroup] ?? []
    }
    
    // MARK: - etc.
    func hasSameChildrenTitles(as textGroup: TextGroup) -> Bool {
        
        let argumentTitles = textGroup.titles()
        let selfTitles = self.titles()
        
        return argumentTitles == selfTitles
    }
    
    private func titles() -> [String] {
        
        var titles: [String] = []
        for textGroup in self {
            
            titles.append(textGroup.title)
        }
        
        return titles
    }
}
