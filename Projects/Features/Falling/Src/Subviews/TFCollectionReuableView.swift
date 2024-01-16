//
//  TFCollectionReuableView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

import DSKit

import SnapKit

class TFCollectionReusableView: UICollectionReusableView {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtSubTitle1M
    return label
  }()

  var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)

    setUpViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUpViews() {
    self.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(14)
      $0.leading.equalToSuperview().offset(12)
      $0.bottom.equalToSuperview().offset(-14)
    }
  }
}
