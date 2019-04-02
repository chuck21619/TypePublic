//
//  DocumentOpener.swift
//  TextEditor
//
//  Created by charles johnston on 1/23/19.
//  Copyright © 2019 Zin Studio. All rights reserved.
//

import Foundation

public class DocumentOpener {
    
    public init(demoString: String? = nil) {
        
        let defaultDemoString = "\n# creation\nRegExr was created by gskinner.com, and is proudly hosted by Media Temple.\n\n## expression\nEdit the Expression & Text to see matches. Roll over matches or the expression for details. PCRE & Javascript flavors of RegEx are supported.\n\n## cheetah\nThe side bar includes a Cheatsheet, full Reference, and Help. You can also Save & Share with the Community, and view patterns you create or favorite in My Patterns.\n\n## toolbox\nExplore results with the Tools below. Replace & List output custom results. Details lists capture groups. Explain describes your expression in plain English.\n\n## idfk\nsomething else\n\n# second group\ntext inside the second group\n\n## nested second group\ntext insdie the nested second group"
        
        self.demoString = demoString ?? defaultDemoString
    }
    
    let demoString: String
    
    func string(_ completion: (String)->()) {
        
        completion(demoString)
    }
}
