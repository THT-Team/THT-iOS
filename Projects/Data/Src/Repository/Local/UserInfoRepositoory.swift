//
//  UserInfoRepositoory.swift
//  Data
//
//  Created by Kanghos on 5/29/24.
//

import Foundation
import RxSwift
import SignUpInterface
import Core

public class UserDefaultUserInfoRepository: UserInfoRepositoryInterface {
  enum Key {
    static let userInfo = "userInfo"
    static let phoneNumber = "phoneNumber"
  }

  public init () {}

  public func savePhoneNumber(_ phoneNumber: String) {
    UserDefaults.standard.setValue(phoneNumber, forKey: Key.phoneNumber)
  }

  public func fetchPhoneNumber() -> Single<String> {
    .create { observer in
      guard let phoneNumber = UserDefaults.standard.string(forKey: Key.phoneNumber) else {
        observer(.failure(NSError(domain: "UserDefaultRepository", code: 0)))
        return Disposables.create()
      }
      observer(.success(phoneNumber))
               
      return Disposables.create { }
    }
  }

  public func fetchUserInfo() -> Single<UserInfo> {
    do {
      guard let userinfo = try UserDefaults.standard.getCodableObject(forKey: Key.userInfo, as: UserInfo.self) else {
        return .error(NSError(domain: "UserDefaultRepository", code: 0))
      }
      return .just(userinfo)
    } catch {
      return .error(error)
    }
  }

  public func updateUserInfo(userInfo: UserInfo) {
    try? UserDefaults.standard.setCodableObject(userInfo, forKey: Key.userInfo)
  }

  public func deleteUserInfo() {
    UserDefaults.standard.removeObject(forKey: Key.userInfo)
  }

  public func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]> {
    Single.create { observer in
      var datas: [Data] = []
      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: key, directoryHint: .isDirectory)

      for fileName in fileNames {
        do {
          let fileURL = path.appending(component: fileName)
          let data = try Data(contentsOf: fileURL)
          datas.append(data)
        } catch {
          print("Failed: Filed Fetch User Photos")
          observer(.failure(error))
          return Disposables.create { }
        }
      }
      observer(.success(datas))
      return Disposables.create { }
    }
  }

  public func saveUserPhotos(key: String, datas: [Data]) -> Single<[String]> {
    return Single.create { observer in
      var urls: [String] = []

      let userDomain = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let directory = userDomain.appendingPathComponent(key, isDirectory: true)

      do {
        if !FileManager.default.fileExists(atPath: directory.path()) {
          try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        for (index, data) in datas.enumerated() {
          let fileName = "\(index).jpeg"
          let url = directory.appendingPathComponent(fileName)
          try data.write(to: url)
          urls.append(fileName)
        }
      } catch {
        print(error.localizedDescription)
        observer(.failure(error))
        return Disposables.create { }
      }
      observer(.success(urls))
      return Disposables.create { }
    }
  }
}
