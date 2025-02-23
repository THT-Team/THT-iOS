//
//  LikeTitleHeader.swift
//  Like
//
//  Created by Kanghos on 2/19/25.
//

import UIKit
import DSKit

final class LikeTitleHeader: TFCollectionReusableView {
  override var horizontalPadding: CGFloat { 12 }
  override var verticalPadding: CGFloat { 10 }

  override func makeUI() {
    self.addSubview(titleLabel)

    titleLabel.font = .thtP1M
    titleLabel.textColor = DSKitAsset.Color.neutral300.color

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(verticalPadding)
      $0.leading.equalToSuperview().offset(horizontalPadding)
      $0.bottom.equalToSuperview().offset(-verticalPadding)
    }
  }
}
