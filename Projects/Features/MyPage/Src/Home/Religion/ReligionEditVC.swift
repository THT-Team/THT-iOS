//
//  ReligionEditVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/24/24.
//

import UIKit

import DSKit

final class ReligionEditVC: TFBaseCollectionViewVC<ReligionEditVM, TFSelectableCVCell> {

  private let _titleLabel = UILabel.setH4TargetBold(text: "종교 를 선택해주세요.", target: "종교")
  override var titleLabel: UILabel {
    _titleLabel
  }
}
