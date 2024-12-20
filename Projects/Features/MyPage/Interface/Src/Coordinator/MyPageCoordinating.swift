//
//  MyPageCoordinating.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation
import SignUpInterface

import Core

public protocol MyPageCoordinatorDelegate: AnyObject {
  func detachMyPage(_ coordinator: Coordinator)
}

public protocol MyPageCoordinating: Coordinator {
  var delegate: MyPageCoordinatorDelegate? { get set }

  func homeFlow()

  func editNicknameFlow(nickname: String)
  func editphotoFlow()
  func editPreferGenderBottomSheetFlow(prefetGender: Gender, listener: BottomSheetListener)
  func editHeightBottomSheetFlow(height: Int, listener: BottomSheetListener)
}

public protocol MyPageCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: MyPageCoordinatingAction)
}

public enum MyPageCoordinatingAction {
  case setting(User)

  case edit(MyPageSection)

  case editNickname(String)
  case editPhoto
  case introduction(String)
  case preferGender(Gender)
  case editHeight(Int)
  case editSmoke(Frequency)
  case editDrink(Frequency)
  case editReligion(Religion)
  case editInterest([Int])
  case editIdealType([Int])
  
  case photoCellTap(index: Int, listener: PhotoPickerDelegate)
  case photoEditOrDeleteAlert(_ listener: TopBottomAlertListener)

  case popToRoot
}
