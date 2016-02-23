//
//  Server.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/19/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Foundation
import AppKit

public class Server: NSObject, NSCoding {
  static let ConfigFileName = ".pipe-board"

  public var title: String?
  public var address: String?
  
  public init(title: String, address: String) {
    self.title = title
    self.address = address
  }
  
  required convenience public init(coder decoder: NSCoder) {
    let title   = decoder.decodeObjectForKey("title") as! String?
    let address = decoder.decodeObjectForKey("address") as! String?
    self.init(title: title!, address: address!)
  }
  
  public func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.title, forKey: "title")
    coder.encodeObject(self.address, forKey: "address")
    coder.encodeObject(self.className, forKey: "className")
  }

  public func valid() -> Bool {
    return title!.present() && address!.present()
  }
  
  public class func saveServers(servers: [Server]) {
    var textArray: [String] = []
    for server in servers {
      textArray.append("\(server.title!): \(server.address!)")
    }
    let text = textArray.joinWithSeparator("\n")

    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = dir.stringByAppendingPathComponent(ConfigFileName);

      //writing
      do {
        try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      }
      catch {print("error on write")}
      
    }
  }

  public class func allServers() -> [Server] {
    var servers: [Server] = []

    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = dir.stringByAppendingPathComponent(ConfigFileName);
      do {
        let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        text.enumerateLines { (line, stop) -> () in
          let attrs = line.componentsSeparatedByString(": ")
          let server = Server.init(title: attrs[0], address: attrs[1])
          servers.append(server)
        }
      } catch {
        print("Error")
      }
    }
    return servers
  }
}