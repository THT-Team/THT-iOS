//
//  EmojiSection.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Domain

public enum ProfileDatailSection {
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

extension User {
  public var profileTitle: String {
    username + ", \(age)"
  }
  public func toProfileSection() -> [ProfileDatailSection] {
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
