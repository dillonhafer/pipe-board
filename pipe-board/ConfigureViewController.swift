//
//  ConfigureViewController.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/19/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Cocoa
import Server

class ConfigureViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
  @IBOutlet weak var serverTable: NSTableView!
  @IBOutlet weak var removeButton: NSButton!
  @IBOutlet weak var errorBox: NSTextField!

  var servers: [Server] = []

  @IBAction func Add(sender: AnyObject) {
    let newServer = Server(title:"", address: "")
    let idx = self.servers.count
    self.servers.append(newServer)
    self.serverTable.insertRowsAtIndexes(NSIndexSet(index: idx), withAnimation: NSTableViewAnimationOptions.SlideDown)
  }

  @IBAction func Save(sender: AnyObject) {
    let text = sender as? NSTextField
    let row = self.serverTable.rowForView(text!)
    let columnName = text!.identifier! as String
    let newValue = text!.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    if row >= 0 {
      let server = self.servers[row]
      switch columnName {
        case "title":
          server.title = newValue
        case "address":
          server.address = newValue
        default:
          return
      }

      if server.valid() {
        Server.saveServers(servers)
        errorBox.hidden = true
      } else {
        errorBox.hidden = false
      }
    }
  }

  @IBAction func Delete(sender: AnyObject) {
    if let server = selectedServerRow() {
      self.serverTable.removeRowsAtIndexes(NSIndexSet(index:self.serverTable.selectedRow),
        withAnimation: NSTableViewAnimationOptions.SlideUp)

      let idx = findServerIndex(server)
      servers.removeAtIndex(idx)
      Server.saveServers(servers)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    removeButton.enabled = false
    fetchServers()
  }

  func findServerIndex(server: Server) -> Int {
    var idx = 0
    for s in servers {
      if s == server {
        return idx
      }
      idx++
    }
    return -1
  }

  func fetchServers() {
    servers = Server.allServers()

    let max = servers.count == 0 ? 0 : servers.count - 1
    let range = NSMakeRange(0, max)

    self.serverTable.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: NSTableViewAnimationOptions.EffectGap)
  }

  func selectedServerRow() -> Server? {
    let selectedRow = self.serverTable.selectedRow;
    if selectedRow >= 0 && selectedRow < self.servers.count {
      return self.servers[selectedRow]
    }
    return nil
  }

  func tableViewSelectionDidChange(notification: NSNotification) {
    let enableButton = selectedServerRow() != nil
    removeButton.enabled = enableButton
    errorBox.hidden = true
  }

  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    return self.servers.count
  }

  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView

    if row < self.servers.count {
      let server = self.servers[row]

      switch tableColumn!.identifier {
        case "title":
          cellView.textField!.stringValue = server.title!
          return cellView
        case "address":
          cellView.textField!.stringValue = server.address!
          return cellView
        default:
          return nil
      }
    } else {
      return nil
    }
  }
}