//
//  Storage.swift
//  Core
//
//  Created by Kanghos on 2024/03/02.
//

import Foundation

@propertyWrapper
public struct Storage<T> {
  private let key: String
  private let defaultValue: T

  public init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  public var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: key)
    }
  }
}
