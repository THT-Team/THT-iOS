//
//  IdealEditVC.swift
//  MyPage
//
//  Created by kangho lee on 7/24/24.
//

import UIKit
import DSKit

import RxSwift
import RxCocoa
import MyPageInterface
import Domain

final class TagPickerEditView: TFBaseView {
  private let title: String
  private let targetString: String

  lazy var titleLabel = UILabel.setH4TargetBold(text: title, target: targetString)

  lazy var collectionView = TagPickerCollectionView()

  lazy var nextBtn = CTAButton(btnTitle: "수정하기", initialStatus: false)

  init(title: String, targetString: String) {
    self.title = title
    self.targetString = targetString
    super.init(frame: .zero)
  }

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral600.color
    let container = UIView()
    self.addSubviews(container, titleLabel, nextBtn)
    container.addSubview(collectionView)

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(33.adjusted)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.greaterThanOrEqualTo(50.adjustedH).priority(.high)
    }

    nextBtn.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(40.adjustedH).priority(.low)
      $0.leading.trailing.equalTo(titleLabel)
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24.adjustedH)
      $0.height.equalTo(54.adjustedH)
    }
  }
}
