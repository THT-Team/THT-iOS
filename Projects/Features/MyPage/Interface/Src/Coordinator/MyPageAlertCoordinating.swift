//
//  MyPageAlertCoordinating.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation

import Core

public protocol MyPageAlertCoordinating: Coordinator {
  var delegate: MyPageAlertCoordinatorDelegate? { get set }

  func showLogoutAlert(listener: LogoutListenr)
  func showDeactivateAlert(listener: DeactivateListener)
}

public protocol MyPageAlertCoordinatorDelegate: AnyObject {
  func detachMyPageAlert()
  func attachMyPageAlert()
}

public protocol MyPageAlertCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: MyPageAlertCoordinatingAction)
}

public enum MyPageAlertCoordinatingAction {
  case showLogoutAlert(LogoutListenr)
  case showDeactivateAlert(DeactivateListener)
}

public protocol MyPageAlertListener { }

public protocol LogoutListenr: MyPageAlertListener, AnyObject {
  func logoutTap()
}

public protocol DeactivateListener: MyPageAlertListener, AnyObject {
  func deactivateTap()
}

