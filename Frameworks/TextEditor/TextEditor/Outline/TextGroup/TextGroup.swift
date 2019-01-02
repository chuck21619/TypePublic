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
    private var iterator: TextGroupIterator? = nil
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
    func createIterator() -> TextGroupIterator {
        
//        if iterator == nil {
            iterator = TextGroupIterator(textGroups: textGroups)
//        }
        
        return iterator!
    }
    
    // TODO: validate this method
    func isDescendant(of parent: TextGroup) -> Bool {
        
        var parentTextGroup: TextGroup? = parent
        
        while parentTextGroup != nil {
            
            if self == parentTextGroup {
                return true
            }
            
            parentTextGroup = parentTextGroup?.parentTextGroup
        }
        
        return false
    }
    
    // MARK: - Description
    override var description: String {
        
        var string = ""
        
        var indentLevel = 0
        
        var currentTextGroup: TextGroup? = self
        
        let iterator = self.createIterator()
        
        while currentTextGroup != nil {
            
            for _ in 0..<indentLevel {
                
                string = "\(string)    "
            }
            string = "\(string)\(currentTextGroup!.title)\n"
            
            let nextTextGroup = iterator.next()
            
            if let nextTextGroup = nextTextGroup {
                
                if currentTextGroup?.textGroups.contains(nextTextGroup) == true {
                    
                    indentLevel += 1
                }
                else {
                    
                    var recursiveTextGroup: TextGroup? = currentTextGroup
                    
                    while nextTextGroup.parentTextGroup?.textGroups.contains(recursiveTextGroup!) == false {
                        
                        indentLevel -= 1
                        recursiveTextGroup = recursiveTextGroup?.parentTextGroup
                    }
                }
            }
            
            currentTextGroup = nextTextGroup
        }
        
        return string
    }
    
    // MARK: - Equatable
    static func == (lhs: TextGroup, rhs: TextGroup) -> Bool {
        
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
    let iteratorCodingKey = "iterator"
    let tokenCodingKey = "tokenCodingKey"
    let parentTextGroupCodingKey = "parentTextGroupCodingKey"
    let textGroupsCodingKey = "textGroupsCodingKey"
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(title, forKey: titleCodingKey)
        aCoder.encode(iterator, forKey: iteratorCodingKey)
        aCoder.encode(token, forKey: tokenCodingKey)
        aCoder.encode(parentTextGroup, forKey: parentTextGroupCodingKey)
        aCoder.encode(textGroups, forKey: textGroupsCodingKey)
    }

    required init?(coder aDecoder: NSCoder) {

        self.title = aDecoder.decodeObject(forKey: titleCodingKey) as? String ?? ""
        self.iterator = aDecoder.decodeObject(forKey: iteratorCodingKey) as? TextGroupIterator
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
     
        var iteratedTextGroup: TextGroup? = self
        let iterator = self.createIterator()
        
        var titles: [String] = []
        while iteratedTextGroup != nil {
            
            titles.append(iteratedTextGroup?.title ?? "")
            iteratedTextGroup = iterator.next()
        }
        
        return titles
    }
}
