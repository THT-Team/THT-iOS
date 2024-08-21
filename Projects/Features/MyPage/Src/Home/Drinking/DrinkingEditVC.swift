//
//  DrinkingEditVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import UIKit
import DSKit

final class DrinkingEditVC: TFBaseCollectionViewVC<DrinkingEditVM, TFSelectableCVCell> {
  private let _titleLabel = UILabel.setH4TargetBold(text: "주량 을 선택해주세요.", target: "주량")
  override var titleLabel: UILabel {
    _titleLabel
  }
}
