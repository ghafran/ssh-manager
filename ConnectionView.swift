//
//  ConnectionView.swift
//  TestApp
//
//  Created by Nini on 14/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation
import AppKit

public class ConnectionView: NSOutlineView
{
/*
    override init()
    {
        self.citem = ConnectionViewItem()
        super.init();
    
    }
    

    
    
    public required init?(coder:NSCoder)
    {
        self.citem = ConnectionViewItem()
        super.init(coder:coder);
    }
*/
    
    lazy var citem: ConnectionViewItem = ConnectionViewItem()
    lazy var observers_ok = false;
    lazy var row = 0;
    lazy var name_clicked:NSString = ""

    func ssh_add_window_closed(sender:AnyObject)
    {
        var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow

        var term = pt.getPseudoRef()
      
        var hostField:NSString = term.ssh_host_field.stringValue;
        var portField:NSString = term.ssh_port_field.stringValue;
        var userField:NSString = term.ssh_user_field.stringValue;
        var keyField:NSString = term.ssh_key_field.stringValue;

        
        hostField.stringByReplacingOccurrencesOfString(" ", withString:"")
        portField.stringByReplacingOccurrencesOfString(" ", withString:"")
        userField.stringByReplacingOccurrencesOfString(" ", withString:"")
        keyField.stringByReplacingOccurrencesOfString(" ", withString:"")

        if (hostField == "")
        {
            return
        }
        
  
        println("Host field: \(citem.port)");
        
       
        term.ssh_host_field.stringValue = "";
        term.ssh_port_field.stringValue = "";
        term.ssh_user_field.stringValue = "";
        term.ssh_key_field.stringValue = "";

       
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource

        var selectedItem = self.itemAtRow(self.row) as ConnectionViewItem!
    
        
        var myItem = ConnectionViewItem()
        
          myItem.name = hostField
        myItem.user = userField
        myItem.port = portField
        myItem.key = keyField
        
        if (selectedItem.folder == true) {
            myItem.parent = selectedItem
            selectedItem.children.addObject(myItem)
           
        }
        else {
            myItem.parent = selectedItem
            (selectedItem.parent!).children.addObject(myItem)
           
        }
             
        self.reloadData()
     
    }
    
    func ssh_edit_window_closed(sender:AnyObject)
    {
        var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow
        
        var term = pt.getPseudoRef()
        
        var hostField:NSString = term.ssh_host_field.stringValue;
        var portField:NSString = term.ssh_port_field.stringValue;
        var userField:NSString = term.ssh_user_field.stringValue;
        var keyField:NSString = term.ssh_key_field.stringValue;
        
        
        hostField.stringByReplacingOccurrencesOfString(" ", withString:"");
        portField.stringByReplacingOccurrencesOfString(" ", withString:"")
        userField.stringByReplacingOccurrencesOfString(" ", withString:"")
        keyField.stringByReplacingOccurrencesOfString(" ", withString:"")
    

        if (hostField == "")
        {
            return
        }
        

        println("Host field: \(citem.port)");
        
        
        term.ssh_host_field.stringValue = "";
        term.ssh_port_field.stringValue = "";
        term.ssh_user_field.stringValue = "";
        term.ssh_key_field.stringValue = "";
        
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        var selectedItem = self.itemAtRow(self.row) as ConnectionViewItem!
        
        selectedItem.name = hostField
        selectedItem.user = userField
        selectedItem.port = portField
        selectedItem.key = keyField
        
        self.reloadData()
    }

    
    func folder_add_window_closed(sender:AnyObject)
    {
         var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow

        var term = pt.getPseudoRef()

        var folder = term.ssh_folder.stringValue;
        
        
        folder.stringByReplacingOccurrencesOfString(" ", withString:"");
        if (folder == "")
        {
            return
        }
        
         println("Folder field: \(folder)");

        term.ssh_folder.stringValue = "";
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        var selectedItem = self.itemAtRow(self.row) as ConnectionViewItem!
        
        var myItem = ConnectionViewItem()
        myItem.name = folder
        
        if (selectedItem.folder == true) {
            
            selectedItem.add(myItem, folder: true)
            
        }
        else {
          
            (selectedItem.parent!).add(myItem, folder: true)
            
        }
        
        self.reloadData()
    }

        
    func folder_edit_window_closed(sender:AnyObject)
    {
         var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow

        var term = pt.getPseudoRef()

        var folder = term.ssh_folder.stringValue;

        term.ssh_folder.stringValue = "";

        folder.stringByReplacingOccurrencesOfString(" ", withString:"");
        if (folder == "")
        {
            return
        }

        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        var selectedItem = self.itemAtRow(self.row) as ConnectionViewItem!
        
        selectedItem.name = folder
    
        self.reloadData()
    }

    
    


    
 override public func menuForEvent(var evt:NSEvent)-> NSMenu?
    {
        super.menuForEvent(evt);
        var pt:NSPoint = self.convertPoint(evt.locationInWindow, fromView:nil);
        self.row=self.rowAtPoint(pt);
        println("Row: \(self.row)");
       
        if (self.observers_ok == false) {
            var ssh_win_observer =  NSNotificationCenter.defaultCenter().addObserverForName("ssh_add_window_closed", object: nil, queue: nil, usingBlock: {
                [unowned self] note in
                self.ssh_add_window_closed(note)
            })
            NSNotificationCenter.defaultCenter().addObserverForName("ssh_edit_window_closed", object: nil, queue: nil, usingBlock: {
                [unowned self] note in
                self.ssh_edit_window_closed(note)
            })
            NSNotificationCenter.defaultCenter().addObserverForName("folder_add_window_closed", object: nil, queue: nil, usingBlock: {
                [unowned self] note in
                self.folder_add_window_closed(note)
            })
            NSNotificationCenter.defaultCenter().addObserverForName("folder_edit_window_closed", object: nil, queue: nil, usingBlock: {
                [unowned self] note in
                self.folder_edit_window_closed(note)
            })
            
            self.observers_ok = true;
        }

        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "ssh_window_closed", name: "ssh_window_closed", object: self)

        return self.defaultMenu(row);
    }
    
    
    func defaultMenu(var row:Int) -> NSMenu? {
        if (row < 0) {
            return nil;
        }
         var theMenu = NSMenu(title: "Gigel");

        var item1:NSMenuItem? = nil;
        var item2:NSMenuItem? = nil;
        var item3:NSMenuItem? = nil;
        var item4:NSMenuItem? = nil;
        var delItem:NSMenuItem? = nil

        var saveConfigItem:NSMenuItem? = nil
        var loadConfigItem:NSMenuItem? = nil
        
        var item:ConnectionViewItem = self.itemAtRow(row) as ConnectionViewItem
        
        item1 = theMenu.insertItemWithTitle("Add connection", action:"addConn", keyEquivalent:"", atIndex:0)


        item3 = theMenu.insertItemWithTitle("Add folder", action:"addFolder", keyEquivalent:"", atIndex:1)
        
        
        if (item.folder == false) {
            item2 = theMenu.insertItemWithTitle("Edit connection", action:"editConn", keyEquivalent:"", atIndex:2)
            delItem = theMenu.insertItemWithTitle("Delete connection", action: "deleteConn", keyEquivalent: "", atIndex: 3)
        }

        else {
            item4 = theMenu.insertItemWithTitle("Edit folder", action:"editFolder", keyEquivalent:"", atIndex:2)
            delItem = theMenu.insertItemWithTitle("Delete folder", action: "deleteConn", keyEquivalent: "", atIndex: 3)
        }
        
        saveConfigItem = theMenu.insertItemWithTitle("Save config", action:"saveConfig", keyEquivalent:"", atIndex:4)
        loadConfigItem = theMenu.insertItemWithTitle("Load config", action:"loadConfig", keyEquivalent:"", atIndex:5)

    //item1!.target = self;
     //   item2!.target = self;
      //  item3!.target = self;
        
        self.name_clicked = item.name;
        self.citem.name = item.name;
        self.citem.user = item.user;
        self.citem.port = item.port;
        self.citem.key = item.key;
       
        
        return theMenu;
    }
    
    func deleteConn()
    {
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        var selectedItem = self.itemAtRow(self.row) as ConnectionViewItem!
        ds.deleteItem(selectedItem)
        self.reloadData()
    }
    
    func saveConfig() {
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        ConnectionHolder.curIdx = 0
        NSKeyedArchiver.archiveRootObject(ds.items, toFile:"sshtree.drt")
    }

    func loadConfig() {
        var ds:ConnectionViewDataSource = self.dataSource() as ConnectionViewDataSource
        ConnectionHolder.curIdx = 0
        var saveFile:String = "sshtree.drt"
        var data = NSKeyedUnarchiver.unarchiveObjectWithFile(saveFile) as NSMutableArray

        ds.items.removeAllObjects()

        for elem in data {
            ds.items.addObject(elem as ConnectionViewItem)
        }
        //ConnectionViewItem.print(data[0] as ConnectionViewItem)
        
        self.reloadData()
            
    }
    
    func addConn() {
        var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow
        var term = pt.getPseudoRef()

         term.ssh_window.makeKeyAndOrderFront(nil)
         term.ssh_window.title="Add connection"
        term.ssh_host_field.stringValue = "";
        term.ssh_port_field.stringValue = "";
        term.ssh_user_field.stringValue = "";
        term.ssh_key_field.stringValue = "";


    }

    func editConn() {
        var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows

        var pt = children![0] as PTYWindow
        var term = pt.getPseudoRef()
        
        
        
        term.ssh_window.makeKeyAndOrderFront(nil);
        term.ssh_window.title = "Edit connection"

        term.ssh_host_field.stringValue = self.citem.name;
        term.ssh_port_field.stringValue = self.citem.port;
        term.ssh_user_field.stringValue = self.citem.user;
        term.ssh_key_field.stringValue = self.citem.key;
       
        
        println("Clicked");
    }

    func addFolder() {
        var deleg = self.delegate();
        var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
        
        var pt = children![0] as PTYWindow
        var term = pt.getPseudoRef()
        
        term.ssh_add_folder.makeKeyAndOrderFront(nil);
        term.ssh_add_folder.title = "Add folder"
        
        println("Add Folder");
    }
    
    func editFolder() {
        
            var deleg = self.delegate();
            var children = ((deleg as ConnectionViewDelegate)).connWindow.childWindows
            
            var pt = children![0] as PTYWindow
            var term = pt.getPseudoRef()
        
            term.ssh_add_folder.makeKeyAndOrderFront(nil);
            term.ssh_add_folder.title = "Edit folder"
            term.ssh_folder.stringValue = self.citem.name;


    }
}
