//
//  TextGroup.swift
//  TextEditor
//
//  Created by charles johnston on 10/16/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class TextGroup: NSObject, NSCoding, NSPasteboardWriting, NSPasteboardReading {
    
    //This method is considered optional because, if readableTypes(for:) returns just a single type, and that type uses the asKeyedArchive reading option, then instances are initialized using init(coder:) instead of this method.
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        
        return nil
    }
    
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        
        // TODO: following example. not sure what this means
        // stackoverflow.com/questions/28656562/storing-and-retrieving-a-custom-object-from-nspasteboard
        return [NSPasteboard.PasteboardType(rawValue: "type.textGroup")]
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        
        // TODO: following example. not sure what this means
        // stackoverflow.com/questions/28656562/storing-and-retrieving-a-custom-object-from-nspasteboard
        return [NSPasteboard.PasteboardType(rawValue: "type.textGroup")]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        
        // TODO: following example. not sure what this means
        // stackoverflow.com/questions/28656562/storing-and-retrieving-a-custom-object-from-nspasteboard
        if type.rawValue != "type.textGroup" {
            
            return nil
        }
        
        return NSKeyedArchiver.archivedData(withRootObject:self)
    }
    
    
    
    // MARK: - Properties
    let title: String
    private var iterator: TextGroupIterator? = nil
    let token: TextGroupToken?
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
        
        self.title = title
        self.textGroups = textGroups
        self.token = token
    }
    
    // MARK: etc.
    func createIterator() -> TextGroupIterator {
        
//        if iterator == nil {
            iterator = TextGroupIterator(textGroups: textGroups)
//        }
        
        return iterator!
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
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {

        aCoder.encode(title, forKey: "title")
        aCoder.encode(iterator, forKey: "iterator")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(parentTextGroup, forKey: "parentTextGroup")
        aCoder.encode(textGroups, forKey: "textGroups")
    }

    required init?(coder aDecoder: NSCoder) {

        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.iterator = aDecoder.decodeObject(forKey: "iterator") as? TextGroupIterator
        self.token = aDecoder.decodeObject(forKey: "token") as? TextGroupToken
        self.parentTextGroup = aDecoder.decodeObject(forKey: "parentTextGroup") as? TextGroup
        self.textGroups = aDecoder.decodeObject(forKey: "textGroups") as! [TextGroup]
    }
}
