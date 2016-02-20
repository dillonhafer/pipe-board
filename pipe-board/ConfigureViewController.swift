//
//  ConfigureViewController.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/19/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Cocoa

class ConfigureViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
  @IBOutlet weak var newTitle: NSTextField!
  @IBOutlet weak var remoteAddress: NSTextField!
  @IBOutlet weak var serverTable: NSTableView!

  @IBOutlet weak var deleteButton: NSButton!
  var servers: [Server] = []

  @IBAction func Save(sender: AnyObject) {
    if !newTitle.stringValue.isEmpty && !remoteAddress.stringValue.isEmpty {
      let newServer = Server(title: newTitle.stringValue, address: remoteAddress.stringValue)
      newTitle.stringValue = ""
      remoteAddress.stringValue = ""

      let newRowIndex = self.servers.count
      self.servers.append(newServer)
      
      self.serverTable.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
      self.serverTable.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection:false)
      self.serverTable.scrollRowToVisible(newRowIndex)
      saveServers()
    }
  }
  
  @IBAction func Delete(sender: AnyObject) {
    if let server = selectedServerRow() {
      deleteButton.hidden = true
      self.serverTable.removeRowsAtIndexes(NSIndexSet(index:self.serverTable.selectedRow),
        withAnimation: NSTableViewAnimationOptions.SlideRight)

      
      var idx = 0
      for s in servers {
        if s == server {
          servers.removeAtIndex(idx)
        }
        idx++
      }
      saveServers()
    }
  }

  override func viewDidLoad() {
      super.viewDidLoad()
      fetchServers()
  }
  
  func saveServers() {
    let data = NSKeyedArchiver.archivedDataWithRootObject(self.servers)
    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "PipeBoard:servers")
  }
  
  func fetchServers() {
    let prefs = NSUserDefaults.standardUserDefaults()
    let data = prefs.objectForKey("PipeBoard:servers") as? NSData
    
    if let data = data {
      let servers = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Server]
      
      if let servers = servers {
        self.servers = servers
        let max = servers.count - 1
        let range = NSMakeRange(0, max)
        
        self.serverTable.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: NSTableViewAnimationOptions.EffectGap)
      }
    }
  }
  
  func selectedServerRow() -> Server? {
    let selectedRow = self.serverTable.selectedRow;
    if selectedRow >= 0 && selectedRow < self.servers.count {
      return self.servers[selectedRow]
    }
    return nil
  }
  
  func tableViewSelectionDidChange(notification: NSNotification) {
    if selectedServerRow() != nil {
      deleteButton.hidden = false
    } else {
      deleteButton.hidden = true
    }
  }
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    return self.servers.count
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    
    if row < self.servers.count {
      let server = self.servers[row]
      
      if tableColumn!.identifier == "title" {
        cellView.textField!.stringValue = server.title!
        return cellView
      }
      
      if tableColumn!.identifier == "address" {
        cellView.textField!.stringValue = server.address!
        return cellView
      }
    }
    return nil
  }
}
