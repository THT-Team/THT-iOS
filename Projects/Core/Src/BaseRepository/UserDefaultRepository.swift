//
//  UserDefaultPersistentRepository.swift
//  Core
//
//  Created by Kanghos on 7/9/24.
//

import Foundation

// TODO: Singletone 으로 변경
public final class UserDefaultRepository: PersistentRepositoryInterface {
  private let userDefault: UserDefaults
  private init() {
    self.userDefault = UserDefaults.standard
  }

  public static let shared = UserDefaultRepository()

  public func remove(key: PersistentKey) {
    userDefault.removeObject(forKey: key.rawValue)
  }

  public func save<T>(_ value: T, key: PersistentKey) {
    userDefault.set(value, forKey: key.rawValue)
  }

  public func fetch<T>(for key: PersistentKey, type: T.Type) -> T? {
    userDefault.object(forKey: key.rawValue) as? T
  }

  @discardableResult
  public func saveModel<T>(_ model: T, key: PersistentKey) -> Bool where T : Encodable {
    guard let _ = try? userDefault.setCodableObject(model, forKey: key.rawValue) else {
      return false
    }
    return true
  }

  public func fetchModel<T>(for key: PersistentKey, type: T.Type) -> T? where T : Decodable {
    guard let model = try? userDefault.getCodableObject(forKey: key.rawValue, as: type) else {
      return nil
    }
    return model
  }
}

extension UserDefaultRepository {
  public func removeUser() {
    PersistentKey.allCases
      .filter { $0 != .deviceKey }
      .forEach { key in
      remove(key: key)
    }
  }
}
