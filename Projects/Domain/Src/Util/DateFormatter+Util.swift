//
//  DateFormatter+Util.swift
//  Domain
//
//  Created by Kanghos on 2/20/25.
//

import Foundation

extension DateFormatter {
  static let yyyyMMddwithDot: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    return dateFormatter
  }()
}

extension Date {
  public func key() -> String {
    DateFormatter.yyyyMMddwithDot.string(from: self)
  }
}
