//
//  UserReportAction.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public enum UserReportAction {
  case block
  case report(String)
  case cancel
}

public enum UserReportType {
  case block(String)
  case report(String, String)
}
