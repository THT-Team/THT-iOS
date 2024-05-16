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
  case nextAtEmail(email: String)

  case nextAtPolicy(Agreement)
  case nextAtNickname(String)
  case nextAtGender(birthday: Date, gender: Gender)
  case nextAtPreferGender(Gender)
  case nextAtPhoto([String])
  case nextAtHeight(Int)
  case nextAtAlcoholTobacco(alcoho: Frequency, tobacco: Frequency)
  case nextAtReligion(Religion)
  case nextAtInterest([Int])
  case nextAtIdealType([Int])
  case nextAtIntroduce(String)
  case nextAtLocation(LocationReq)
  
  case nextAtHideFriends
  case nextAtSignUpComplete

  
  case webViewTap(listner: WebViewDelegate)
  case birthdayTap(Date, listener: BottomSheetListener)
  case heightLabelTap(Int, listener: BottomSheetListener)
  case photoCellTap(index: Int, listener: PhotoPickerDelegate)
}
