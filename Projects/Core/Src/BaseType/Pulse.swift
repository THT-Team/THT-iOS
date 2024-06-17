//
//  Pulse.swift
//  Core
//
//  Created by Kanghos on 6/28/24.
//

import Foundation

@propertyWrapper
public struct Pulse<Value> {

  public var value: Value {
    didSet {
      riseValueUpdatedCount()
    }
  }

  public internal(set) var valueUpdatedCount = UInt.min

  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }

  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: Pulse<Value> {
    self
  }

  private mutating func riseValueUpdatedCount() {
    valueUpdatedCount &+= 1
  }
}
