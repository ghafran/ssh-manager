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

func getMyPath() -> NSString
{
    var myPath:NSString = NSFileManager.defaultManager().currentDirectoryPath
    return myPath
}

func openSSHConnection(var selectedItem:ConnectionViewItem, var term:PseudoTerminal)
{
    if selectedItem.folder == true {
        return
    }
    
    // [[iTermController sharedInstance] refreshSoftwareUpdateUserDefaults];
    
    var ssh_host:NSString = "ssh://" + selectedItem.user + "@" +  selectedItem.name + ":" + selectedItem.port
    
    var controller = iTermController.sharedInstance();
    
    selectedItem.key = selectedItem.key.stringByReplacingOccurrencesOfString(" ", withString:"");

    if (selectedItem.key != "") {
        controller.launchWithSSH_Key(nil, inTerminal: term, withURL: ssh_host, isHotkey: false, makeKey: false, command: selectedItem.key);
    }
    else {
        controller.launchBookmark(nil, inTerminal: term, withURL: ssh_host, isHotkey: false, makeKey: false, command: nil);
    }
}