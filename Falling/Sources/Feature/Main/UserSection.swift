//
//  UserSection.swift
//  Falling
//
//  Created by SeungMin on 2023/10/06.
//

import RxDataSources

struct UserSection {
  var header: String
  var items: [Item]
}

extension UserSection: AnimatableSectionModelType {
  typealias Item = UserDTO
  var identity: String {
    return self.header
  }
  
  init(original: UserSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension UserDTO: IdentifiableType, Equatable {
  static func == (lhs: UserDTO, rhs: UserDTO) -> Bool {
    lhs.identity == rhs.identity
  }

  var identity: Int {
    return userIdx
  }
}
