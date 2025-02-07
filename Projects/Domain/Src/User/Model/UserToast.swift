//
//  UserToast.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public enum UserToast {
  case report
  case block

  public var message: String {
    switch self {
    case .report:
      return "신고하기가 완료되었습니다. 해당 사용자와\n서로 차단되며, 신고 사유는 검토 후 처리됩니다."
    case .block:
      return "차단하기가 완료되었습니다. 해당 사용자와\n서로 차단되며 설정에서 확인 가능합니다."
    }
  }
}
