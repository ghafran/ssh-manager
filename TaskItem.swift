//
//  TaskItem.swift
//  TreeView1
//
//  Created by Nini on 28/09/14.
//  Copyright (c) 2014 Nini. All rights reserved.
//

import Foundation

class TaskItem
{
    
    init()
    {
        task = NSTask()
        messages = NSMutableArray()
        id = 0
    }
    
    var task: NSTask
    var messages: NSMutableArray
    var id:uint32
}