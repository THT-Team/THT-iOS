//
//  SignUpCoordinatorAction.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import SignUpInterface
import AuthInterface

public enum SignUpCoordinatingAction {

  case loginType(SNSType)

  case nextAtPhoneNumber(phoneNumber: String)
  case nextAtAuthCode
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
  
  case nextAtHideFriends([ContactType])
  case nextAtSignUpComplete

  
  case webViewTap(listner: WebViewDelegate)
  case birthdayTap(Date, listener: BottomSheetListener)
  case heightLabelTap(Int, listener: BottomSheetListener)
  case photoCellTap(index: Int, listener: PhotoPickerDelegate)

  case agreementWebView(_ url: URL)
}
