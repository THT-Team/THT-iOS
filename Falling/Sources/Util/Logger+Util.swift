//
//  Logger+Util.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation
import OSLog

extension Logger {
  /// Using your bundle identifier is a great way to ensure a unique identifier.
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  /// All logs related to presentation logic
  static let view = Logger(subsystem: subsystem, category: "view")
  
  /// All logs related to business logic
  static let logic = Logger(subsystem: subsystem, category: "logic")
  
  /// All logs related to response data from the server or storage data
  static let data = Logger(subsystem: subsystem, category: "data")
}

struct TFLogger {
  static var view = Logger.view
  
  static var logic = Logger.logic
  
  static let data = Logger.data
}

