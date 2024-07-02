//
//  InterestEditVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/24/24.
//

import UIKit
import DSKit

import RxSwift
import RxCocoa
import SignUpInterface
import MyPageInterface
import Domain

extension Domain.EmojiType: EmojiPropertyType { }

final class InterestEditVC: BaseEmojiEditVC<InterestEditVM> {
  override var titleModel: AttributedTitleInfo {
    return AttributedTitleInfo(title: "관심사를 선택해주세요.", targetText: "관심사")
  }
}

final class IdealEditVC: BaseEmojiEditVC<IdealEditVM> {
  override var titleModel: AttributedTitleInfo {
    return AttributedTitleInfo(title: "이상형 을 선택해주세요.", targetText: "이상형")
  }
}
