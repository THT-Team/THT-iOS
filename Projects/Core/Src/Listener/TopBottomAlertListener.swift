//
//  TopBottomListener.swift
//  Core
//
//  Created by Kanghos on 6/18/24.
//

import Foundation

public protocol MenuProtocol {
  static var title: String { get }
  static var menuList: [MenuProtocol] { get }

  var key: String { get }
  var label: String { get }
}

public protocol TopBottomAlertListener {
  func didTapAction(_ action: TopBottomAction)
}

public enum TopBottomAction {
  case top
  case bottom
  case cancel
}

public protocol BlockOrReportAlertListener {
  func didTapAction(_ action: BlockOrReportAction)
}

public enum BlockOrReportAction {
  case block
  case report
  case cancel
}

public protocol BlockAlertListener {
  func didTapAction(_ action: BlockAlertAction)
}

public enum BlockAlertAction {
  case block
  case cancel
}

public protocol ReportAlertListener {
  func didTapAction(_ action: ReportAlertAction)
}

public enum ReportAlertAction {
  case didTap(_ menu: MenuProtocol)
  case cancel
}
