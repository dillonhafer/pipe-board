//
//  main.swift
//  pipe-board-cli
//
//  Created by Dillon Hafer on 2/21/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Foundation
import Server

for argument in Process.arguments {
  switch argument {
  case "list":
    let servers = Server.allServers()
    print("Servers (\(servers.count)):");
    for server in servers {
      print("  • \(server.title!) (\(server.address!))")
    }
  default:
    print("Pipe Board © 2016 Dillon Hafer. All rights reserved.");
  }
}