//
//  DateReusableView.swift
//  ChatRoom
//
//  Created by Kanghos on 1/18/25.
//

import UIKit
import DSKit

public final class DateReusableView: TFCollectionReusableView {

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = .thtP2R
    return label
  }()

  public override func setUpViews() {
    addSubviews(dateLabel)

    dateLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  public func bind(_ model: String) {
    dateLabel.text = model
  }
}
