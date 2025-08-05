//
//  WithdrawalCollectionViewCell.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/3/24.
//

import UIKit

import DSKit
import Domain

final class WithdrawalCollectionViewCell: TFBaseCollectionViewCell {
  var model: WithdrawalReason? {
    didSet {
      if let model {
        bind(model)
      }
    }
  }

  override var isHighlighted: Bool {
    didSet {
      if self.isHighlighted {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut ) {
          [self] in
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
      } else {
        self.transform = .identity
      }
    }
  }

  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        self.contentView.backgroundColor = DSKitAsset.Color.neutral500.color
      } else {
        self.contentView.backgroundColor = DSKitAsset.Color.neutral600.color
      }
    }
  }
  
  private let hStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.distribution = .fill
    $0.isUserInteractionEnabled = false
  }

  private let emojiLabel = UILabel().then {
    $0.font = .thtH3R
    $0.textAlignment = .center
  }

  private let reasonLabel = UILabel().then {
    $0.font = .thtSubTitle2R
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  override func makeUI() {
    contentView.addSubview(hStackView)
    contentView.layer.cornerRadius = 6
    contentView.layer.masksToBounds = true
    contentView.backgroundColor = DSKitAsset.Color.neutral600.color

    hStackView.addArrangedSubviews([emojiLabel, reasonLabel])
    
    reasonLabel.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(20).priority(.low)
    }

    hStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.top.bottom.equalToSuperview().inset(20)
    }
  }

  func bind(_ model: WithdrawalReason) {
    self.emojiLabel.text = model.emoji
    self.reasonLabel.text = model.label
  }
}

struct WithdrawalReasonModel {
  let emoji: String
  let text: String
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct WithdrawalViewPreview: PreviewProvider {
//
//  static var previews: some SwiftUI.View {
//    UIViewPreview {
//      let comp = WithdrawalCollectionViewCell()
//      comp.bind(.init(emoji: "🔴", text: "당분간 폴링 사용을\n중단하려고 함"))
//      return comp
//    }
//    .frame(width: 300, height: 150)
//    .previewLayout(.sizeThatFits)
//  }
//}
//#endif
