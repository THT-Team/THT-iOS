//
//  TimestampModel.swift
//  AuthInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation

import Core

public struct TimeStamp {
  public let timeStamp: Date
  public let timeDuration: Int
  public var timeString: String {
    let timeInterval = timeDuration.d - abs(timeStamp.timeIntervalSinceNow) + 1

    let min = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
    let sec = Int(timeInterval.truncatingRemainder(dividingBy: 60))
    return (min * 60) + (sec) > .zero
    ? String(format: "%02d:%02d", min, sec)
    : String(format: "%02d:%02d", 0, 0)
  }

  public var isAvailable: Bool {
    abs(Int(timeStamp.timeIntervalSinceNow)) < timeDuration
  }

  public init(timeDuration: Int) {
    self.timeDuration = timeDuration
    self.timeStamp = Date()
  }
}
