//
//  MyPageInfoCollectionViewCell.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import UIKit

import DSKit

import Then
import SnapKit
import MyPageInterface

enum MyPage {
  enum CellType {
    case editable
    case uneditable
    case tag([TagItemViewModel])
  }
}

final class MyPageInfoCollectionViewCell: TFBaseCollectionViewCell {
  var model: MyPageInfoCollectionViewCellViewModel?

  private lazy var titleLabel = UILabel().then {
    $0.font = UIFont.thtSubTitle1Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "타이틀 텍스트"
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }

  private lazy var contentLabel = UILabel().then {
    $0.font = .thtSubTitle1R
    $0.text = "콘텐츠 레이블입니다."
    $0.numberOfLines = 2
    $0.textAlignment = .right
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

  private lazy var containerView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral600.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }

  override func makeUI() {
    contentView.addSubview(containerView)
    contentView.backgroundColor = .clear
    containerView.addSubviews(titleLabel, contentLabel)

    containerView.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(10)
      $0.top.equalToSuperview().inset(5)
      $0.leading.trailing.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(15)
      $0.bottom.equalToSuperview().offset(-15)
    }

    contentLabel.snp.makeConstraints {
      $0.top.bottom.equalTo(titleLabel)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }

  public func bind(_ viewModel: MyPageInfoCollectionViewCellViewModel) {
    self.model = viewModel
    titleLabel.text = viewModel.title
    contentLabel.text = viewModel.content as? String

    contentLabel.textColor = viewModel.isEditable
    ? DSKitAsset.Color.primary500.color
    : DSKitAsset.Color.neutral400.color
  }
}
