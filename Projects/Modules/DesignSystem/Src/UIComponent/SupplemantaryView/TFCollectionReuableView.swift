//
//  TFCollectionReuableView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

public protocol PaddingType {
  var horizontalPadding: CGFloat { get }
  var verticalPadding: CGFloat { get }
}

open class TFCollectionReusableView: TFBaseCollectionReusableView, PaddingType {
  open var horizontalPadding: CGFloat { 0 }
  open var verticalPadding: CGFloat { 10 }

  public lazy var titleLabel: UILabel = {
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

  open override func makeUI() {
    self.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(verticalPadding)
      $0.leading.equalToSuperview().offset(horizontalPadding)
      $0.bottom.equalToSuperview()
    }
  }
}
