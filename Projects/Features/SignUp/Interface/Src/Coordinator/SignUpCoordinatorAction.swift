//
//  SignUpCoordinatorAction.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import AuthInterface
import Core
import Domain

public protocol WebViewDelegate: AnyObject {
  func didReceiveAddress(_ address: String)
}

public enum SignUpCoordinatingAction {

  case loginType(SNSType)
  case backAtEmail
  case nextAtEmail

  case nextAtPolicy
  case nextAtNickname
  case nextAtGender
  case nextAtPreferGender
  case nextAtPhoto
  case nextAtHeight
  case nextAtAlcoholTobacco
  case nextAtReligion
  case nextAtInterest
  case nextAtIdealType
  case nextAtIntroduce
  case nextAtLocation
  
  case nextAtHideFriends
  case nextAtSignUpComplete

  
  case webViewTap(listner: WebViewDelegate)
  case birthdayTap(Date, listener: BottomSheetListener)
  case heightLabelTap(Int, listener: BottomSheetListener)
  case photoCellTap(index: Int, handler: PhotoPickerHandler?)

  case agreementWebView(_ url: URL)
  case photoEditOrDeleteAlert(_ listener: TopBottomAlertListener)
}
