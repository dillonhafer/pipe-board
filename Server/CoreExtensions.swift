//
//  CoreExtensions.swift
//  pipe-board
//
//  Created by Dillon Hafer on 2/20/16.
//  Copyright © 2016 Dillon Hafer. All rights reserved.
//

import Foundation

extension String {
  func trim() -> String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  func blank() -> Bool {
    return self.trim().isEmpty
  }
  func present() -> Bool {
    return !self.blank()
  }
}