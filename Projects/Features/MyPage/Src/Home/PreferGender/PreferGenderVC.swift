//
//  PreferGenderVC.swift
//  MyPage
//
//  Created by kangho lee on 7/23/24.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa
import Domain

final class PreferGenderVC: TFBaseCollectionViewVC<PreferGenderVM, PreferGenderCell> {
  private let _titleLabel = UILabel.setH4TargetBold(text: "선호 성별 을 선택해주세요.", target: "선호 성별")
  override var titleLabel: UILabel {
    _titleLabel
  }

  override func createLayout() -> UICollectionViewFlowLayout {
    .init().then {
      $0.minimumInteritemSpacing = 12.adjusted
    }
  }

  public override func cellSize(width: CGFloat, spacing: CGFloat) -> CGSize {

    let numberOfCellsInLine: CGFloat = 3
    let cellWidth = (width - spacing * (numberOfCellsInLine - 1)) / numberOfCellsInLine
    let cellHeight = cellWidth * 104 / 96
    return CGSize(width: cellWidth, height: cellHeight + 20)
  }
}
