//
//  DateFormatter+Util.swift
//  Core
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

extension DateFormatter {

  static var unixDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    formatter.locale = Locale(identifier: "ko-KR")

    return formatter
  }

  static var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    formatter.dateFormat = "hh:MM a"
//    formatter.locale = Locale(identifier: "ko-KR")
    return formatter
  }
}

public extension String {
  func toDate() -> Date {
    DateFormatter.unixDateFormatter.date(from: self) ?? Date()
  }
}

public extension Date {
  func toTimeString() -> String {
    DateFormatter.timeFormatter.string(from: self)
  }
}
