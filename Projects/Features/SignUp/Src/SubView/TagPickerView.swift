//
//  InterestPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit
import SignUpInterface

import DSKit

public struct AttributedTitleInfo {
  public let title: String
  public let targetText: String

  public init(title: String, targetText: String) {
    self.title = title
    self.targetText = targetText
  }
}

final class TagPickerView: TFBaseView {

  private let titleInfo: AttributedTitleInfo
  private let subTitleInfo: AttributedTitleInfo

  init(titleInfo: AttributedTitleInfo, subTitleInfo: AttributedTitleInfo) {
    self.titleInfo = titleInfo
    self.subTitleInfo = subTitleInfo
    super.init(frame: .zero)
  }

  lazy var titleLabel = UILabel.setTargetBold(text: self.titleInfo.title, target: self.titleInfo.targetText, font: .thtH1B, targetFont: .thtH1B)

  lazy var subTitleLabel = UILabel.setTargetBold(text: self.subTitleInfo.title, target: self.subTitleInfo.targetText, font: .thtH4B, targetFont: .thtH4B)

  lazy var collectionView = TagPickerCollectionView()

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      subTitleLabel,
      collectionView,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(titleLabel)
    }

    collectionView.setContentHuggingPriority(.defaultLow, for: .vertical)
    collectionView.snp.makeConstraints {
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.equalTo(350).priority(.low)
    }

    nextBtn.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(40.adjustedH)
      $0.trailing.equalTo(collectionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}
