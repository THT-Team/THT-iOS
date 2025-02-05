//
//  TFTitleWithReportHeaderView.swift
//  DSKit
//
//  Created by Kanghos on 2/5/25.
//

import UIKit

import RxSwift
import SnapKit

public final class TFTitleWithReportHeaderView: TFBaseCollectionReusableView {

  enum Metric {
    static let horizontalPadding: CGFloat = 16
  }

  private let titleLabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color.withAlphaComponent(0.6)
    label.font = UIFont.thtP2Sb
    return label
  }()

  public override func makeUI() {
    self.backgroundColor = .clear

    self.addSubviews(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.horizontalPadding)
      $0.leading.equalToSuperview()
    }
  }
}
