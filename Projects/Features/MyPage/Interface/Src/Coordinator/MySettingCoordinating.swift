//
//  MySettingCoordinating.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation
import SignUpInterface

import Core
import Domain

public enum MySettingCoordinatorOption {
  case finish
  case toRoot
}

public protocol MySettingCoordinating: Coordinator {
  var finishFlow: ((MySettingCoordinatorOption) -> Void)? { get set }

  func settingHomeFlow(_ user: User)

  func editUserContactsFlow()
  func alarmSettingFlow()
  func accountSettingFlow()

  func webViewFlow(_ title: String?, _ url: URL)
}

public protocol MySettingCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: MySettingCoordinatingAction)
}

public enum MySettingCoordinatingAction {
  case finish
  case logout
  case toRoot

  case editPhoneNumber(phoneNumber: String)
  case editEmail(email: String)
  case editUserContacts

  case alarmSetting

  case feedback
  case webView(WebViewInfo)

  case accountSetting

  case selectWithdrawal
  case WithdrawalDetail(WithdrawalReason)
  case withdrawalComplete
}

public struct WebViewInfo {
  public let title: String?
  public let url: URL

  public init(title: String?, url: URL) {
    self.title = title
    self.url = url
  }
}
