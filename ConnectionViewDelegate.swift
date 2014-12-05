//
//  ConnectionViewDelegate.swift
//  TreeView1
//
//  Created by Nini on 17/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation
import AppKit

public class ConnectionViewDelegate : NSObject,NSOutlineViewDelegate
{
    @IBOutlet var mView: NSOutlineView!
    @IBOutlet var connWindow: NSWindow!
  
    override init()
    {
        super.init()
    }
    
    func outlineView(outlineView: NSOutlineView!, viewForTableColumn tableColumn: NSTableColumn!, item: AnyObject!) -> NSView!
    {
        
        println("c5")
        var cellview = (outlineView.makeViewWithIdentifier("cell1", owner: self)) as NSTableCellView
        
        cellview.textField?.stringValue = (item as ConnectionViewItem).name
        
        cellview.textField?.stringValue = (item as ConnectionViewItem).name
        cellview.imageView?.image = (item as ConnectionViewItem).icon
        
        return cellview
    }
    
    
    func outlineViewSelectionDidChange(notification: NSNotification!)
    {
        if (mView.selectedRow < 0) {
            return
        }
        
        println(mView.selectedRow)
        var cellview = (mView.makeViewWithIdentifier("cell1", owner: self)) as NSTableCellView
        
        var c:NSTableCellView = mView.viewAtColumn(0, row:mView.selectedRow, makeIfNecessary: false) as NSTableCellView
        
        var host:NSString = c.textField!.stringValue
        
        var selectedItem = mView.itemAtRow(mView.selectedRow) as ConnectionViewItem!

        
        var children = connWindow.childWindows
        
        var pt = children![0] as PTYWindow
        var term = pt.getPseudoRef()
        
        //iTermController.sharedInstance().saveAllTabsArrangementForOneServer(selectedItem.name + "?lay.conf")
       // iTermController.sharedInstance().loadWindowArrangementWithName(selectedItem.name + "?lay.conf")
        
        var ssh = "ssh " + selectedItem.user + "@" + selectedItem.name + " -p " + selectedItem.port;
        if ( selectedItem.key  != "" ) {
            ssh = ssh + " -i " + selectedItem.key;
        }
        
        iTermController.sharedInstance().replaceWindowArrangementWithName(selectedItem.name + "?lay.conf", ssh)
    }
    
}