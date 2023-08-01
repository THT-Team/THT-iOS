//
//  UserDefaultAccess.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

// https://swiftsenpai.com/swift/create-the-perfect-userdefaults-wrapper-using-property-wrapper/
// 원시타입과 JSON 객체 모두 저장할 수 있는  Storage
@propertyWrapper
struct DataStorage<T: Codable> {
  private let key: String
  private let defaultValue: T

  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      guard let data = UserDefaults.standard.object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(T.self, from: data)
      else {
        return defaultValue
      }

      return value
    }

    set {
      let data = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(data, forKey: key)
    }
  }
}
