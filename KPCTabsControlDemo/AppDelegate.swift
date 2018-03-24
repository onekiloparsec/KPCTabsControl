//
//  AppDelegate.swift
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa
import KPCTabsControl

// Bug from Apple ?
// https://stackoverflow.com/questions/47051682/unknown-window-class-null-in-interface-builder-file-creating-generic-window-i
class WorkedAroundWindow: NSWindow {}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

