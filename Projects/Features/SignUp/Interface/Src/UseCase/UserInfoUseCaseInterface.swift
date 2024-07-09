//
//  UserInfoUseCaseInterface.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/29/24.
//

import Foundation
import RxSwift

public protocol UserInfoUseCaseInterface {
  func savePhoneNumber(_ phoneNumber: String)
  func fetchPhoneNumber() -> Single<String>
  func fetchUserInfo() -> Single<UserInfo>
  func updateUserInfo(userInfo: UserInfo)
  func updateMarketingAgreement(isAgree: Bool)
  func deleteUserInfo()
  func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]>
  func saveUserPhotos(key: String, datas: [Data]) -> Single<[String]>
}
