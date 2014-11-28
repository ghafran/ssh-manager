//
//  ConnectionViewItem.swift
//  TestApp
//
//  Created by Nini on 13/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation
import AppKit

struct ConnectionHolder {
    static var curIdx = 0;
}

class ConnectionViewItem: NSObject, NSCoding
{
    var children : NSMutableArray
    var icon: NSImage!
    var parent:ConnectionViewItem?
    var name:NSString
    var user:NSString
    var port:NSString
    var key:NSString
    
    var parentKey:NSString
    var childKey:NSString
    
    var folder:Bool
   
    required init(coder aDecoder: NSCoder) {
        println("Init with coder")
        self.name = ""
        self.user = ""
        self.port = ""
        self.key = ""
        self.parentKey = ""
        self.childKey = ""
        self.folder = false;
        parent = nil
        self.children = NSMutableArray()
        self.icon = NSImage(named: "mac_icon")

        super.init()
        loadWithCoder(coder: aDecoder)
    }
    
    override func isEqual(anObject: AnyObject?) -> Bool
    {
        if ((anObject as ConnectionViewItem).name == self.name) {
            return true
        }
        return false
    }


    override init()
    {
        println("Init connitem!!!!!!")
        self.name = ""
        self.user = ""
        self.port = ""
        self.key = ""
        self.parentKey = ""
        self.childKey = ""
        self.folder = false;
        parent = nil
        self.children = NSMutableArray()
        self.icon = NSImage(named: "mac_icon")
        
        
        if self.icon == nil{
            println("Icon nil")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
       // var objKey:NSNumber = NSNumber(int: Int32(self.hash));
        
        var hashString = String(self.hash)
        ConnectionHolder.curIdx++
        var cidx = String(ConnectionHolder.curIdx)
        
        println("Hash is \(hashString)")
        var childCountStr = String(children.count)
       
        aCoder.encodeObject(childCountStr, forKey:NSString(string: "childCount" + cidx))
        aCoder.encodeObject(name, forKey:NSString(string:"name" + cidx))
        aCoder.encodeObject(user, forKey: NSString(string:"user" + cidx))
        aCoder.encodeObject(port, forKey: NSString(string:"port" + cidx))
        aCoder.encodeObject(key,  forKey: NSString(string:"key" + cidx))
        aCoder.encodeBool(folder, forKey:NSString(string:"folder" + cidx))

        println("Item name: " + self.name)

        for var i=0; i < children.count; i++
        {
            (children[i] as ConnectionViewItem).encodeWithCoder(aCoder)
        }
    
    }
    
       func loadWithCoder(coder aDecoder: NSCoder)
       {
        
            println("loadWithCoder")
            ConnectionHolder.curIdx++
            var cidx = String(ConnectionHolder.curIdx)
 
            var childCountKey = "childCount" + cidx
            var childCount = aDecoder.decodeObjectForKey(NSString(string: childCountKey)) as NSString

            var childCountInteger = childCount.integerValue
        
            folder = aDecoder.decodeBoolForKey(NSString(string: "folder" + cidx)) as Bool
            name = aDecoder.decodeObjectForKey(NSString(string:"name" + cidx)) as NSString
            if folder == false {
                //icon = aDecoder.decodeObjectForKey("icon") as NSImage
                user = aDecoder.decodeObjectForKey(NSString(string:"user" + cidx)) as NSString
                port = aDecoder.decodeObjectForKey(NSString(string:"port" + cidx)) as NSString
                key = aDecoder.decodeObjectForKey(NSString(string:"key" + cidx)) as NSString
            }
        
            else {
                self.icon = NSImage(named: "folder_icon")
            }
        
            for var i = 0 ; i < childCountInteger; i++ {
                var citem = ConnectionViewItem()
                citem.loadWithCoder(coder:aDecoder)
                citem.parent = self
                println("Citem name : \(citem.name), citem parent: \(self.name)")
                self.children.addObject(citem)
            }

    }

   
    
    /*
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.name = ""
        self.user = ""
        self.port = ""
        self.parentKey = ""
        self.childKey = ""
        self.key = ""
        self.folder = false;
        parent = nil
        self.children = NSMutableArray()
        self.icon = NSImage(named: "mac_icon")
        loadWithCoder(coder: decoder)
       
    }
*/
    
    class func print(item: ConnectionViewItem)
    {
        println("   Name: \((item as ConnectionViewItem).name)")
        println("       Children: \((item as ConnectionViewItem).children.count)")
        for child in item.children {
          
            print(child as ConnectionViewItem)
        }
    }
    
 
    func count() -> Int
    {
        return self.children.count
    }
    
    func compareItems(other:AnyObject!, first: AnyObject!) -> NSComparisonResult
    {
        
        return (other as ConnectionViewItem).name.compare((first as ConnectionViewItem).name)
    }
    
    func add(var child:ConnectionViewItem, var folder:Bool=false) -> ConnectionViewItem
    {
        child.parent = self
        child.parent!.icon = NSImage(named: "folder_icon")
        child.parent!.folder = true

        if (folder == true)
        {
            child.icon = NSImage(named: "folder_icon")
            child.folder = true
        }

        self.children.addObject(child)
        
        return child
    }
    
    func deleteItem(var item:ConnectionViewItem)
    {
        if (self.name == item.name) {
            self.parent?.children.removeObject(item)
            self.parent = nil

            return
        }
        for child in item.children {
            deleteItem(child as ConnectionViewItem)
        }
    }
    
    func add(var name:String, user:NSString="", port:NSString="", key:NSString="", host:NSString="") -> ConnectionViewItem
    {
        println("add conviewitem \(name)")
        var child = ConnectionViewItem()
        child.name = name
        child.user = user
        child.port = port
     
        child.key = key
        child.parent = self
        child.parent!.icon = NSImage(named: "folder_icon")
        child.parent!.folder = true
        
        self.children.addObject(child)
        
        return child
    }
 
}