//
//  Date+Util.swift
//  Core
//
//  Created by Kanghos on 7/22/24.
//

import Foundation

// https://stackoverflow.com/questions/31590316/how-do-i-find-the-number-of-days-in-given-month-and-year-using-swift
public extension Date {
  func daysInMonth(month: Int, year: Int) -> Int {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    if let d = Calendar.current.date(from: dateComponents),
       let interval = Calendar.current.dateInterval(of: .month, for: d),
       let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day {
      return days }
    else {
      return 30
    }
  }
}
