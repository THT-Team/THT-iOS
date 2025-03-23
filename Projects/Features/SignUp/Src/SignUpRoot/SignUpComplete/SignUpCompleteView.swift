//
//  SignUpCompleteView.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import UIKit

import DSKit

final class SignUpCompleteView: TFBaseView {
  lazy var containerView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "환영해요! 💫\n모든 준비가 끝났어요"
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH3B
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  lazy var descLabel = UILabel().then {
    $0.text = "폴링에 한 번 빠져 보시겠어요"
    $0.font = .thtH5R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  private lazy var gradientView = TFShimmerGradientView()

  lazy var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20 * Metric.wRatio
  }

  lazy var nextBtn = CTAButton(btnTitle: "네, 좋아요", initialStatus: true)
  
  private enum Metric {
    static let wRatio: CGFloat = UIScreen.main.bounds.width / 390.0
    static let hRatio: CGFloat = UIScreen.main.bounds.height / 844
  }

  override func makeUI() {
    addSubview(containerView)
    containerView.addSubviews(
      titleLabel,
      descLabel,
      gradientView,
      imageView,
      nextBtn
    )

    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(140.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38)
    }

    descLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(38)
    }
    gradientView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(184).multipliedBy(Metric.wRatio)
    }

    imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(160).multipliedBy(Metric.wRatio)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(54)
    }

  }
  
  func startAnimation() {
    gradientView.animate(frame: gradientView.bounds)
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SignUpCompleteViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let component = SignUpCompleteView()
      component.imageView.image =  DSKitAsset.Image.Test.test1.image

      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
