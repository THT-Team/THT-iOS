//
//  Int+Util.swift
//  DSKit
//
//  Created by SeungMin on 8/14/25.
//

extension Int {
  public func formatDistance() -> String {
    guard self < Int.max && self >= 0 else { return "0m" }
    
    if self >= 1_000 {
      let km = Double(self) / 1_000
      let text = km < 10 ? String(format: "%.1f", km) : String(format: "%.0f", km)
      return "\(text)km"
    } else {
      return "\(self)m"
    }
  }
}
