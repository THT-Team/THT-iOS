//
//  FallingCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol FallingCoordinatorDelegate: AnyObject {
  

}
public protocol FallingCoordinating: Coordinator {
  var delegate: FallingCoordinatorDelegate? { get set }

  func homeFlow()
  func chatRoomFlow()

}

public protocol FallingAlertCoordinating {
  func reportOrBlockAlert(_ listener: BlockOrReportAlertListener)
  func blockAlertFlow(_ listener: BlockAlertListener)
  func userReportAlert(_ listener: ReportAlertListener)
}

public enum FallingHomeNavigationAction {
  case toReportBlockAlert(listener: BlockOrReportAlertListener)
  case toReportAlert(listener: ReportAlertListener)
  case toBlockAlert(listener: BlockAlertListener)
}

public protocol FallingHomeActionDelegate: AnyObject {
  func invoke(_ action: FallingHomeNavigationAction)
}
