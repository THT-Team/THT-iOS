//
//  EmojiSection.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Domain

public enum ProfileDetailSection {
  case photo([UserProfilePhoto])
  case text(String, String)
  case emoji(String, [EmojiType], title: (String, String)?)
  case blocks([(String, String)])

  public var count: Int {
    switch self {
    case let .photo(items): return items.count
    case .text:
      return 1
    case let .emoji(_, items, _):
      return items.count
    case let .blocks(items):
      return items.count
    }
  }

  public var sectionTitle: String? {
    switch self {
    case .photo: return nil
    case let .text(title, _):
      return title
    case let .emoji(title, _, _):
      return title
    case .blocks: return nil
    }
  }
}

extension UserInfoType {
  public func toUserCardSection() -> [ProfileDetailSection] {
    var sections: [ProfileDetailSection] = [
      .emoji("내 관심사", interestsList, title: nil),
      .emoji("내 이상형", idealTypeList, title: nil),
      .blocks([
        ("키", "\(10)cm"),
        ("흡연",  Frequency.frequently.title),
        ("술", Frequency.frequently.title),
        ("종교", Religion.buddhism.title),
      ])
    ]
    if !introduction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      sections.append(.text("자기소개", introduction))
    }

    return sections
  }
}

extension UserDetailInfoType {
  public var profileTitle: String {
    username + ", \(age)"
  }
  public func toProfileSection() -> [ProfileDetailSection] {
      [
        .photo(userProfilePhotos),
        .emoji("관심사", interestsList, title: (profileTitle, address)),
        .emoji("이상형", idealTypeList, title: nil),
        .blocks([
          ("키", "\(tall)cm"),
          ("흡연",  smoking.title),
          ("술", drinking.title),
          ("종교", religion.title),
        ]),
        .text("자기소개", introduction + "\n\n\nasfasdf")
      ]
  }

  public func toUserCardSection() -> [ProfileDetailSection] {
    var sections: [ProfileDetailSection] = [
      .emoji("내 관심사", interestsList, title: nil),
      .emoji("내 이상형", idealTypeList, title: nil),
      .blocks([
        ("키", "\(tall)cm"),
        ("흡연",  smoking.title),
        ("술", drinking.title),
        ("종교", religion.title),
      ]),
    ]
    if !introduction.isEmpty {
      sections.append(.text("자기소개", introduction))
    }
    return sections
  }
}


public struct ProfileInfoSection {
  public typealias Item = EmojiType

  public var items: [Item]
  public var header: String
  public var introduce: String?

  public init(header: String, items: [Item]) {
    self.items = items
    self.header = header
    self.introduce = nil
  }

  public init(header: String, introduce: String) {
    self.items = []
    self.header = header
    self.introduce = introduce
  }
}
