//
//  ConnectionViewDataSource.swift
//  TestApp
//
//  Created by Nini on 13/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation
import AppKit

struct holder
{
    static var count = 0
}

class ConnectionViewDataSource: NSObject, NSOutlineViewDataSource
{
    @IBOutlet var sshView: NSTextView!
    
    
    override init()
    {
        self.items = []
       
        super.init()
        
        if (holder.count == 0)
        {
            var saveFile:String = "sshtree.drt"
            var path = getMyPath() + "/" + saveFile
            if (NSFileManager.defaultManager().fileExistsAtPath((path)) == true)
            {
                var data = NSKeyedUnarchiver.unarchiveObjectWithFile(saveFile) as NSMutableArray
                
                self.items.removeAllObjects()
                
                for elem in data {
                    self.items.addObject(elem as ConnectionViewItem)
                }
            }

            holder.count = 1
        }
        
        else {
            holder.count = 1
        
            var root1 = ConnectionViewItem()
            root1.name = ""
        
            self.items.addObject(root1)
            root1.folder = true
            root1.icon = NSImage(named: "folder_icon")
        }
    }
    
    func deleteItem(var item:ConnectionViewItem)
    {
        del_Item((item as ConnectionViewItem), name: item.name)
    }
    
    private func del_Item(var item:ConnectionViewItem, var name:NSString)
    {
        if ((item as ConnectionViewItem).name == name) {
               (item as ConnectionViewItem).deleteItem(item)
        }
        
        for child in (item as ConnectionViewItem).children
        {
               del_Item((child as ConnectionViewItem), name: name)
        }
    }

    func printItem(item:ConnectionViewItem)
    {
        if (item.children.count == 0 ) {
          //  println("Child count 0")
            return
        }
        for child in item.children
        {
            println("           ------>" + (child as ConnectionViewItem).name)
            printItem(child as ConnectionViewItem)
        }
    }

    func print_items()
    {
        for item in self.items
        {
            printItem(item as ConnectionViewItem)
         
        }

    }
    
    func searchAll(text:NSString, item:ConnectionViewItem?, what:ConnectionViewItem)
    {
        if (item == nil) {
            return
        }
         let itemName:NSString = item!.name
        
      
         for child in item!.children
            {
                 if ( itemName == text) {
                    if (item!.folder == false) {
                        item!.parent!.add(what)
    
                    }
                    else {
                        item!.add(what)
    
                    }
                    return
                }

                searchAll(text, item:child as? ConnectionViewItem, what:what)
                
        }
        
    }

    func updateElement(text:NSString, what:ConnectionViewItem)
    {
        for item in self.items {
           searchAll(text, item:item as? ConnectionViewItem, what:what)
        }
  
       
    }
    
    func outlineView(outlineView: NSOutlineView!, numberOfChildrenOfItem item: AnyObject!) -> Int
    {	
        println("c1")
        var count = (item != nil ? (item as ConnectionViewItem).children.count : self.items.count)
        println("Count: \(count)")
        return count
    }
    
    func outlineView(outlineView: NSOutlineView!, isItemExpandable item: AnyObject!) -> Bool
    {
        println("C2")
        return (item == nil) ? true : ((item as ConnectionViewItem).children.count != 0 ? true : false)
    }
    
    func outlineView(outlineView: NSOutlineView!, child index: Int, ofItem item: AnyObject!) -> AnyObject!
    {
        println("Called3")
        
        println("Index is \(index)")
        if item == nil {
            return self.items.objectAtIndex(index)
        }
        
        return (item as ConnectionViewItem).children.objectAtIndex(index)
    }
    
    func outlineView(outlineView: NSOutlineView!, objectValueForTableColumn tableColumn: NSTableColumn!, byItem item: AnyObject!) -> AnyObject!
    {
        println("c4")
        
        if item == nil {
            println("Item is nil")
            return self.items.objectAtIndex(0).name
        }
        
        var name = (item as ConnectionViewItem).name
        var key = (item as ConnectionViewItem).key
        var user = (item as ConnectionViewItem).user
        var port = (item as ConnectionViewItem).port
        
        println ("Name is " + name)
        
        //  sshView.insertText(item.name)
        
       // NSNotificationCenter.defaultCenter().postNotification(name: //"ssh_row_info_notification", )(
        
        return item.name
    }
    
    
    
    var items: NSMutableArray
    
    
    //TODO need to implement
    //optional func outlineView(outlineView: NSOutlineView!, viewForTableColumn tableColumn: NSTableColumn!, //item:AnyObject!) -> NSView!
    
    //from delegate
}
