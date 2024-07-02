//
//  TitleHeaderReusableCollectionVIew.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit

final class HeaderDescriptionView: UICollectionReusableView {

  override init(frame: CGRect) {
    super.init(frame: .zero)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let titleLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH4M
    $0.textAlignment = .center
  }

  private let subTitleLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.font = .thtP1R
  }

  func makeUI() {
    addSubviews(titleLabel, subTitleLabel)
    backgroundColor = DSKitAsset.Color.neutral700.color

    titleLabel.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
    }

    subTitleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(5).priority(.high)
      $0.bottom.equalToSuperview().offset(-42)
    }
  }

  func bind(title: String?, subTitle: String?) {
    titleLabel.text = title
    subTitleLabel.text = subTitle
  }
}

