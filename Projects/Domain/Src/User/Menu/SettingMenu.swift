//
//  SettingMenu.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/24/24.
//

import Foundation

public struct SectionModel<ItemType> where ItemType: MenuType {
  public typealias Item = ItemType
  public let type: MySetting.Section
  public let items: [Item]
  
  public init(type: MySetting.Section, items: [Item]) {
    self.type = type
    self.items = items
  }
}

public protocol MenuType {
  var title: String { get }
  var content: String? { get }
}

public enum MySetting {
  public enum Section: Int, CaseIterable {
    case banner
    case account
    case activity
    case location
    case notification
    case support
    case law
    case accoutSetting

    public var header: String? {
      switch self {
      case .banner: return nil
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

    public var footer: String? {
      switch self {
      case .activity:
        return "나의 연락처에 저장된 지인들을 폴링에서 보고 싶지 않다면 서로에게 노출되지\n않도록 설정 할 수 있어요."
      case .location:
        return "나의 위치를 업데이트해서 상대방과 매칭률을 높혀보세요."
      default: return nil
      }
    }
  }

  public struct Item: Hashable, MenuType {
    public let title: String
    public let content: String?
    public let identifier = UUID()

    public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    public init(title: String, content: String? = nil) {
      self.title = title
      self.content = content
    }
  }

  public struct LinkItem: Hashable, MenuType {
    public let title: String
    public let content: String?
    public let url: URL
    public let identifier = UUID()

    public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    public init(title: String, content: String? = nil, url: URL) {
      self.title = title
      self.content = content
      self.url = url
    }
  }

  public enum MenuItem: MenuType, Hashable {
    case item(Item)
    case linkItem(LinkItem)

    public var title: String {
      switch self {
      case .item(let item):
        return item.title
      case .linkItem(let item):
        return item.title
      }
    }

    public var content: String? {
      switch self {
      case .item(let item):
        return item.content
      case .linkItem(let item):
        return item.content
      }
    }

    public var identifier: UUID {
      switch self {
      case .item(let item):
        return item.identifier
      case .linkItem(let item):
        return item.identifier
      }
    }

    public var url: URL? {
      switch self {
      case .linkItem(let item):
        return item.url
      default:
        return nil
      }
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
  }
}
