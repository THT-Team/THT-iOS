//
//  JSONStorage.swift
//  Core
//
//  Created by Kanghos on 5/14/24.
//

import Foundation

extension UserDefaults {

    public func setCodableObject<Object>(
        _ object: Object, forKey: String
    ) throws where Object: Encodable {

        let data = try JSONEncoder().encode(object)
        self.set(data, forKey: forKey)
    }

    public func getCodableObject<Object>(
      forKey: String,
      as type: Object.Type
    ) throws -> Object where Object: Decodable {

        guard let data = self.data(forKey: forKey) else {
            throw NSError(domain: "UserDefaults", code: 0, userInfo: nil)
        }
        return try JSONDecoder().decode(type, from: data)
    }
}

@propertyWrapper
public struct CodableStorage<T: Codable> {
  private let key: String
  private let defaultValue: T?

  public init(key: String, defaultValue: T? = nil) {
    self.key = key
    self.defaultValue = defaultValue
  }

  public var wrappedValue: T? {
    get {
      guard let object = try? UserDefaults.standard.getCodableObject(forKey: key, as: T.self) else {
        return defaultValue
      }
      return object
    }
    set {
      if newValue == nil {
        UserDefaults.standard.removeObject(forKey: key)
      }
      try? UserDefaults.standard.setCodableObject(newValue, forKey: key)
    }
  }
}

