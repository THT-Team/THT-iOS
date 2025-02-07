//
//  TFCollectionReuableView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

open class TFCollectionReusableView: UICollectionReusableView {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color.withAlphaComponent(0.6)
    label.font = UIFont.thtP2Sb
    return label
  }()

  public var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: .zero)

    setUpViews()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func setUpViews() {
    self.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}
