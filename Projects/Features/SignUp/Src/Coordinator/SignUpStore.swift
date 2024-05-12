//
//  SignUpStore.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import Foundation
import Core

protocol Signing {
  
}

public struct SignUpStore {

  enum Key: String {
    case snsType
    case phoneNumber
    case email
    case policy
    case nickname
    case gender
    case birthday
    case preferGender
    case photo

    // ------- API 미구현 ---------
    case height
    case smoke
    case drink
    case religion
    // ------- -------- ---------

    case interest
    case ideal
    case introduce
    case address
    case avoidFriends
  }
  @Storage<String>(key: Key.snsType.rawValue, defaultValue: "")
  public static var snstype

  @Storage<String>(key: Key.phoneNumber.rawValue, defaultValue: "")
  public static var phoneNumber


  @Storage<String>(key: Key.email.rawValue, defaultValue: "")
  public static var email

  @Storage<Int>(key: Key.email.rawValue, defaultValue: -1)
  public static var policy

  @Storage<String>(key: Key.nickname.rawValue, defaultValue: "")
  public static var nickname

  @Storage<String>(key: Key.gender.rawValue, defaultValue: "")
  public static var gender

  @Storage<String>(key: Key.preferGender.rawValue, defaultValue: "")
  public static var preferGender

  @Storage<String>(key: Key.birthday.rawValue, defaultValue: "")
  public static var birthday

  @Storage<String>(key: Key.photo.rawValue, defaultValue: "")
  public static var photo

  @Storage<[String]>(key: Key.height.rawValue, defaultValue: [])
  public static var height

  @Storage<String>(key: Key.smoke.rawValue, defaultValue: "")
  public static var smoke

  @Storage<String>(key: Key.drink.rawValue, defaultValue: "")
  public static var drink

  @Storage<String>(key: Key.religion.rawValue, defaultValue: "")
  public static var religion

  @Storage<[String]>(key: Key.interest.rawValue, defaultValue: [])
  public static var interest

  @Storage<[String]>(key: Key.ideal.rawValue, defaultValue: [])
  public static var ideal

  @Storage<String>(key: Key.introduce.rawValue, defaultValue: "")
  public static var introduce

  @Storage<String>(key: Key.address.rawValue, defaultValue: "")
  public static var address

  @Storage<String>(key: Key.avoidFriends.rawValue, defaultValue: "")
  public static var avoidFriends
}

extension SignUpStore {
//  func checkStartFlow() -> SignUpCoordinatingAction {
//    if phone
//  }
}
