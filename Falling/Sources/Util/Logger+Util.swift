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

  /// Logs the view cycles like a view that appeared.
  static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

  /// All logs related to tracking and analytics.
  static let data = Logger(subsystem: subsystem, category: "data")
}

struct TFLogger {
  static var viewCycle = Logger.viewCycle

  static let data = Logger.data
}

