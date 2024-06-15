//
//  MySettingCoordinating.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation
import SignUpInterface

import Core

public protocol MySettingCoordinatorDelegate: AnyObject {
  func detachMySetting()
  func attachMySetting(_ user: User)
}

public protocol MySettingCoordinating: Coordinator {
  var delegate: MySettingCoordinatorDelegate? { get set }

  func settingHomeFlow(_ user: User)
  func editPhoneNumberFlow()
  func editEmailFlow()

  func editUserContactsFlow()
  func alarmSettingFlow()
  func accountSettingFlow()

  func feedBackFlow()

  func webViewFlow(_ title: String?, _ url: URL)
}

public protocol MySettingCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: MySettingCoordinatingAction)
}

public enum MySettingCoordinatingAction {
  case finish
  
  case editPhoneNumber
  case editEmail
  case editUserContacts

  case alarmSetting

  case feedback
  case cs(URL)

  case locationPolicy(URL)
  case servicePolicy(URL)
  case privacyPolicy(URL)

  case license(URL)
  case businessInfo(URL)

  case accountSetting

  case showLogoutAlert(LogoutListenr)
  case showDeactivateAlert(DeactivateListener)
}
