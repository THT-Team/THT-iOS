//
//  MyPageInfoCollectionViewCellViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//

import Foundation
import SignUpInterface
import MyPageInterface
import DSKit

struct MyPageInfoCollectionViewCellViewModel {
  let model: MyPageSection
  var title: String {
    model.title
  }
  var content: Any {
    switch model {
    case .birthday(let content):
      return content
    case .gender(let gender):
      return gender.title
    case .introduction(let content):
      return content
    case .preferGender(let gender):
      return gender.title
    case .height(let height):
      return "\(height)cm"
    case .smoking(let frequency):
      return frequency.title
    case .drinking(let frequency):
      return frequency.title
    case .religion(let religion):
      return religion.title
    case .interest(let array):
      return array.map { emoji in
        TagItemViewModel(emojiCode: emoji.emojiCode, title: emoji.name)
      }
    case .idealType(let array):
      return array.map { emoji in
        TagItemViewModel(emojiCode: emoji.emojiCode, title: emoji.name)
      }
    }
  }
  var isEditable: Bool {
    switch model {
    case .birthday, .gender: return false
    default: return true
    }
  }
}

extension MyPageInfoCollectionViewCellViewModel: Equatable {
  static func == (lhs: MyPageInfoCollectionViewCellViewModel, rhs: MyPageInfoCollectionViewCellViewModel) -> Bool {
    lhs.model.title == rhs.model.title
  }
}
