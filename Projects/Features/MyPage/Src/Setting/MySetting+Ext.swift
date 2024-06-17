//
//  MySetting+Ext.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

enum MySetting {
  enum Section: Int {
    case account
    case activity
    case location
    case notification
    case support
    case law
    case accoutSetting

    var header: String {
      switch self {
      case .account:
        return "계정"
      case .activity:
        return "활동"
      case .location:
        return "위치"
      case .notification:
        return "알림"
      case .support:
        return "지원"
      case .law:
        return "법률"
      case .accoutSetting:
        return "계정 설정"
      }
    }

    var footer: String? {
      switch self {
      case .activity:
        return "나의 연락처에 저장된 지인들을 폴링에서 보고 싶지 않다면 서로에게 노출되지\n않도록 설정 할 수 있어요."
      case .location:
        return "나의 위치를 업데이트해서 상대방과 매칭률을 높혀보세요."
      default: return nil
      }
    }
  }

  struct Item: Hashable {
    let title: String
    let identifier = UUID()

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
  }
}
