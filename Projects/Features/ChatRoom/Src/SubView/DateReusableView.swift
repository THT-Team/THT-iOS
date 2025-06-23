//
//  DateReusableView.swift
//  ChatRoom
//
//  Created by Kanghos on 1/18/25.
//

import UIKit
import DSKit

public final class DateReusableView: TFBaseCollectionReusableView {

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = .thtP2R
    return label
  }()

  public override func makeUI() {
    let leftLine = UIView()
    leftLine.backgroundColor = DSKitAsset.Color.neutral50.color
    
    let rightLine = UIView()
    rightLine.backgroundColor = DSKitAsset.Color.neutral50.color
    
    addSubviews(leftLine, rightLine, dateLabel)

    dateLabel.snp.makeConstraints {
      $0.bottom.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.height.equalTo(30)
    }
    
    leftLine.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(30)
      $0.trailing.equalTo(dateLabel.snp.leading).offset(-10)
      $0.centerY.equalTo(dateLabel)
      $0.height.equalTo(1)
    }
    
    rightLine.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(30)
      $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
      $0.centerY.equalTo(dateLabel)
      $0.height.equalTo(1)
    }
  }

  public func bind(_ model: String) {
    dateLabel.text = model
  }
}
