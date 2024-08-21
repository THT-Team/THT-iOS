//
//  SmokingEditVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class SmokingEditVC: TFBaseCollectionViewVC<SmokingEditVM, TFSelectableCVCell> {
  private let _titleLabel = UILabel.setH4TargetBold(text: "흡연 스타일을 선택해주세요.", target: "흡연")
  override var titleLabel: UILabel {
    _titleLabel
  }
}
