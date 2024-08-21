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
    case .preferGender(let gender, let listner):
      return gender.title
    case .height(let height, _):
      return "\(height)cm"
    case .smoking(let frequency, _):
      return frequency.title
    case .drinking(let frequency, _):
      return frequency.title
    case .religion(let religion, _):
      return religion.title
    case .interest(let array, _):
      return array.map { emoji in
        TagItemViewModel(emojiCode: emoji.emojiCode, title: emoji.name)
      }
    case .idealType(let array, _):
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
