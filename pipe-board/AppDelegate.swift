//
//  AppDelegate.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/19/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Cocoa
import Server

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  let title = "📋"
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2);
  let menu = NSMenu()
  let popover = NSPopover()
  var eventMonitor: EventMonitor?
  var servers: [Server] = []

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Setup events
    self.servers = Server.allServers()
    popover.contentViewController = ConfigureViewController(nibName: "ConfigureViewController", bundle: nil)

    eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
      if self.popover.shown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()
    
    // Setup menu
    if let button = statusItem.button {
      button.title = title
      button.action = "createMenu"
    }
  }
  
  func createMenu() {
    NSApp.activateIgnoringOtherApps(true)
    closePopover(1)
    menu.removeAllItems()
    createServerItems()
    menu.addItem(NSMenuItem.separatorItem())
    menu.addItem(NSMenuItem(title: "Configure", action: "togglePopover:", keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "Quit", action: "terminate:", keyEquivalent: "q"))
    statusItem.popUpStatusItemMenu(menu)
  }
  
  func showPopover(sender: AnyObject?) {
    if let button = statusItem.button {
      popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
    }
    eventMonitor?.start()
  }
  
  func closePopover(sender: AnyObject?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }
  
  func togglePopover(sender: AnyObject?) {
    if popover.shown {
      closePopover(sender)
    } else {
      showPopover(sender)
    }
  }
  
  func sendClipboard(item: NSMenuItem) {
    let server = self.servers[self.menu.indexOfItem(item)]
    let command = "echo '\(getClipboardString())' | pbcopy"

    let task = NSTask()
    task.launchPath = "/usr/bin/ssh"
    task.arguments = [server.address!, command]
    task.launch()
  }
  
  func getClipboardString() -> String {
    let clipboard = NSPasteboard.generalPasteboard()
    return clipboard.stringForType(NSPasteboardTypeString)!
  }
  
  func createServerItems() {
    for server in self.servers {
      self.menu.addItem(NSMenuItem.init(title: server.title!, action: "sendClipboard:", keyEquivalent: ""))
    }
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {}
}