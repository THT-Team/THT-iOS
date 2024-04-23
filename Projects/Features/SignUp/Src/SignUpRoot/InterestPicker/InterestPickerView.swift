//
//  InterestPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

final class InterestTagPickerView: TFBaseView {

  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }
  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "관심사를 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH1B
    $0.asColor(targetString: "관심사", color: DSKitAsset.Color.neutral50.color)
  }

  lazy var subTitleLabel: UILabel = UILabel().then {
    $0.text = "내 관심사 3개를 선택해주세요."
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH4B
    $0.asColor(targetString: "내 관심사", color: DSKitAsset.Color.neutral50.color)
  }

  lazy var collectionView: UICollectionView = {
    let layout = LeftAlignCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.isScrollEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(container)

    container.addSubviews(
      titleLabel,
      subTitleLabel,
      collectionView,
      nextBtn
    )

    container.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.trailing.equalToSuperview().inset(30)
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
      $0.top.equalTo(collectionView.snp.bottom).offset(30)
      $0.trailing.equalTo(titleLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(60)
    }
  }
}
