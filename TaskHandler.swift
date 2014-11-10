        //
        //  TaskHandler.swift
        //  TreeView1
        //
        //  Created by Nini on 25/09/14.
        //  Copyright (c) 2014 Nini. All rights reserved.
        //
        
        import Foundation
        import AppKit
        
        class TaskHandler {
            
            init() {
                self.tasks = NSMutableDictionary()
            }
            
            private func StringForInt(var key:uint32) -> NSString
            {
                return NSString(format: "%d", key)
            }
            
            func addTextControlObserver(var textControl:NSTextView, var handle: NSFileHandle)
            {
                NSNotificationCenter.defaultCenter().addObserverForName("NSFileHandleDataAvailableNotification", object: handle, queue: nil)
                    { _ in
                        
                        var outData: NSData =  handle.availableData
                        if outData.length != 0 {
                            var outStr:NSString! = NSString(data:outData, encoding:NSUTF8StringEncoding)
                            textControl.appendTextAndScroll(outStr)
                            handle.waitForDataInBackgroundAndNotify()
                        }
                        else {
                            NSNotificationCenter.defaultCenter().removeObserver(self, name : "NSFileHandleDataAvailableNotification", object: handle)
                        }
                }
                
            }
            
            func addTask(var exe:NSString, var arguments: [String], var textControl:NSTextView, var id:uint32=0)
            {
                var inPipe: NSPipe = NSPipe()   //shell input
                var outPipe: NSPipe = NSPipe()  //shell output
                var errPipe: NSPipe = NSPipe()
                
                var pipe: NSPipe = NSPipe()
                
                var task = NSTask()
                
                var stringId = StringForInt(id)
                
                task.launchPath = exe
                task.arguments = arguments
                
                task.standardError = errPipe
                task.standardOutput = outPipe
                //  task.standardInput = inPipe
                
                
                
                task.launch()
                
                outPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
                errPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
                NSNotificationCenter.defaultCenter().addObserverForName("NSTextDidChangeNotification", object: textControl, queue: nil)
                    { _ in
                        var data:NSData = textControl.textStorage!.string.dataUsingEncoding(NSUTF8StringEncoding)!
                        var buf:UnsafePointer<UInt8>
                      //  data.getBytes(buffer: buf, data.length)
                       // println (textControl.textStorage!.string)
                       // task.standardInput.write(buffer: buf, maxLength: data.length)
                }
                
                
                var ti = TaskItem()
                tasks.setObject(ti, forKey: stringId)
                
                
                addTextControlObserver(textControl, handle: outPipe.fileHandleForReading)
                addTextControlObserver(textControl, handle: errPipe.fileHandleForReading)
            }
            
            func getMessage(var taskId:uint32) -> NSString
            {
                var task: NSTask?
                var id = taskId
                
                if let taskItem = tasks.objectForKey(StringForInt(id)) as TaskItem?
                {
                    
                    if taskItem.messages.count == 0 {
                        return ""
                    }
                    
                    var stringItem = taskItem.messages.objectAtIndex(0) as NSString
                    taskItem.messages.removeObjectAtIndex(0)
                    return stringItem
                }
                
                return ""
            }
            
            func getAllMessages(var taskId:uint32) -> NSMutableArray
            {
                var id = taskId
                
                if let taskItem = tasks.objectForKey(StringForInt(id)) as TaskItem?
                {
                    var msgs = taskItem.messages
                    taskItem.messages.removeAllObjects()
                    return msgs
                }
                
                return []
            }
            
            var tasks: NSMutableDictionary
            
        }