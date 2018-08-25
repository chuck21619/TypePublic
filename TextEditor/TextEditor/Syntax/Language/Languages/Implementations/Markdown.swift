//
//  Markdown.swift
//  TextEditor
//
//  Created by charles johnston on 8/23/18.
//  Copyright © 2018 Zin Studio. All rights reserved.
//

import Foundation

class Markdown: Language {
    
    let name: String
    let definedLanguage: DefinedLanguage
    let keywords: [Keyword]
    
    init() {
        
        let italicFont = NSFontManager().convert(NSFont.systemFont(ofSize: 11), toHaveTrait: .italicFontMask)
        let boldFont = NSFont.boldSystemFont(ofSize: 11)
        let monospaceFont = NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 11)
    
        name = "Markdown"
        definedLanguage = .Markdown
        
        
        func makeKeyword( _ regexPattern: String, _ attributeKey: NSAttributedStringKey, _ attributeValue: Any) -> Keyword {
            
            let attribute = Attribute(key: attributeKey, value: attributeValue)
            let keyword = Keyword(regexPattern: regexPattern, attribute: attribute)
            
            return keyword
        }
        
        keywords = [// #h1 titles, ##h2 titles,  etc.
                    makeKeyword("^\\s*#+", .foregroundColor, NSColor.brown),
    
                    // _italic font_ *italic font*
                    makeKeyword("(_|\\*)[^_\\*\\n]+\\1", .font, italicFont),
    
                    // **bold font** __bold font__
                    makeKeyword("(__|\\*\\*)[^_\\*\\n]+\\1", .font, boldFont),
    
                    // `monospace font` belongs in backticks
                    makeKeyword("`[^`\\n]+`", .font, monospaceFont),
    
                    // *** horizontal rule // can use *** or --- or ___
                    makeKeyword("^(___+|---+|\\*\\*\\*+)", .foregroundColor, NSColor.magenta),
    
                    // + unordered list items // can use * or - or +
                    makeKeyword("^\\s*(\\* |- |\\+ )", .foregroundColor, NSColor.orange),
    
                    // 1. list items
                    makeKeyword("^\\s*[0-9]\\. ", .foregroundColor, NSColor.red),

                    //[link title](www.linkAddress.com)
//                    makeKeyword("(\\[(?!.*\\[.*\\]).*\\])\\s*(\\(.*?\\))",
                    //(\[(?!.*\[.*\]).*\])\s*(\(.*?\))
                    
//                    // [link title](www.linkAddress.com) // this is for the link title
//                    makeKeyword("(?<=\\[)(.*?)(?=\\])(?=\\]\\(.*\\))", .foregroundColor, NSColor.purple),
    
//                             //[link title](www.linkAddress.com) // this is for the link address
//                            makeKeyword("(?<=\\[.*\\].*\\()(.*?)(?=\\))", .foregroundColor, NSColor.purple)
                    ]
    }
    
    func attributes(for string: String, changedRange: NSRange) -> [(attribute: Attribute, range: NSRange)] {
        
        var attributes: [(attribute: Attribute, range: NSRange)] = []
        
        
        
        
        
        //(\\(.*?\\))
        let regexStr = "(?<linkTitle>\\[(?=[^\\(\\)\\[\\]]*\\]\\().*?\\])(?<linkAddress>\\(.*?\\))"
        
        guard let regex = try? NSRegularExpression(pattern: regexStr) else {
            return []
        }
        
        regex.enumerateMatches(in: string, range: changedRange) { (match, flags, stop) in
            
            guard let match = match else {
                return
            }
            
            print("")
            
            let titleAttribute = Attribute(key: .foregroundColor, value: NSColor.systemGreen)
            let titleRange = match.range(withName: "linkTitle")
            
            let addressAttribute = Attribute(key: .foregroundColor, value: NSColor.systemYellow)
            let addressRange = match.range(withName: "linkAddress")
            
            attributes.append((attribute: titleAttribute, range: titleRange))
            attributes.append((attribute: addressAttribute, range: addressRange))
        }
        
        
        
        
        
        
        for keyword in keywords {
            
            let regexStr = keyword.regexPattern
            
            
            guard let regex = try? NSRegularExpression(pattern: regexStr) else {
                return []
            }
            
            regex.enumerateMatches(in: string, range: changedRange) { (match, flags, stop) in
                
                guard let match = match else {
                    return
                }
                
                attributes.append((attribute: keyword.attribute, range: match.range))
            }
        }
        
        return attributes
    }
}
