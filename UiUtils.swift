//
//  UiUtils.swift
//  TreeView1
//
//  Created by Nini on 28/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation
import AppKit

extension NSTextView
{
    func appendTextAndScroll(text:NSString)
    {
        var attr = NSAttributedString(string: text)
        self.textStorage!.appendAttributedString(attr)
        self.scrollRangeToVisible(NSMakeRange(self.string!.utf16Count, 0)) //same as countElements or countCharacters
    }
    
    
}