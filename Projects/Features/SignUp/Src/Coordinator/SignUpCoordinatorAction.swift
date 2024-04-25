//
//  SignUpCoordinatorAction.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation
import SignUpInterface

public enum SignUpCoordinatingAction {

  case phoneNumber
  case kakao
  case google
  case apple
  case naver

  case nextAtPhoneNumber
  case nextAtAuthCode
  case nextAtEmail

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

  case birthdayTap(Date, listener: BottomSheetListener)
  case heightLabelTap(Int, listener: BottomSheetListener)
  case photoCellTap(index: Int, listener: PhotoPickerDelegate)

}
