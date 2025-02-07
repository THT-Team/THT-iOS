//
//  LikeButton.swift
//  Like
//
//  Created by Kanghos on 2/5/25.
//

import UIKit
import DSKit

extension UIButton {
  static func makeCapsuleButton(type: LikeBtnType) -> UIButton {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString(type.appearance.title)
    titleAttribute.font = UIFont.thtSubTitle2M
    titleAttribute.foregroundColor = type.appearance.titleColor
    config.baseBackgroundColor = type.appearance.backgroundColor
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }

  enum LikeBtnType {
    case chat
    case disLike

    struct Appearence {
      let title: String
      let titleColor: UIColor
      let backgroundColor: UIColor
    }

    var appearance: Appearence {
      switch self {
      case .chat:
        return Appearence(
          title: "대화하기",
          titleColor: DSKitAsset.Color.neutral700.color,
          backgroundColor: DSKitAsset.Color.primary500.color)
      case .disLike:
        return Appearence(
          title: "다음에",
          titleColor: DSKitAsset.Color.neutral300.color,
          backgroundColor: DSKitAsset.Color.neutral500.color)
      }
    }
  }
}
