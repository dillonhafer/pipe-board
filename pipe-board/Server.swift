//
//  Server.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/19/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Foundation
import AppKit

class Server: NSObject, NSCoding {
  var title: String?
  var address: String?
  
  init(title: String, address: String) {
    self.title = title
    self.address = address
  }
  
  required convenience init(coder decoder: NSCoder) {
    let title   = decoder.decodeObjectForKey("title") as! String?
    let address = decoder.decodeObjectForKey("address") as! String?
    self.init(title: title!, address: address!)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.title, forKey: "title")
    coder.encodeObject(self.address, forKey: "address")
    coder.encodeObject(self.className, forKey: "className")
  }
  
  class func saveServers(servers: [Server]) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(servers)
    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "PipeBoard:servers")
  }
  
  class func allServers() -> [Server] {
    let prefs = NSUserDefaults.standardUserDefaults()
    
    if let data = prefs.objectForKey("PipeBoard:servers") as? NSData {
      let servers = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Server]
      return servers!
    }
    return []
  }
}