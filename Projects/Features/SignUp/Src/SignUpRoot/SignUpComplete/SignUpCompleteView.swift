//
//  SignUpCompleteView.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import UIKit

import DSKit

final class SignUpCompleteView: TFBaseView {

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "환영해요!💫\n모든 준비가 끝났어요"
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH3B
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  lazy var descLabel = UILabel().then {
    $0.text = "폴링에 한 번 빠져 보시겠어요?"
    $0.font = .thtH5R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  private lazy var gradientView = TFShimmerGradientView()

  lazy var imageView = UIImageView().then {
    $0.image = nil
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }

  lazy var nextBtn = CTAButton(btnTitle: "네, 좋아요", initialStatus: true)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      descLabel,
      gradientView,
      imageView,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjustedH)
    }

    descLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(22.adjusted)
      $0.leading.trailing.equalTo(titleLabel)
    }

    gradientView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(44)
      $0.size.equalTo(184.adjusted)
    }

    imageView.snp.makeConstraints {
      $0.center.equalTo(gradientView)
      $0.size.equalTo(160.adjusted)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(22.adjusted)
      $0.bottom.equalToSuperview().offset(-64.adjustedH)
      $0.height.equalTo(54.adjustedH)
    }
  }
  
  func startAnimation() {
    gradientView.animate(frame: gradientView.bounds)
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SignUpCompleteViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let component = SignUpCompleteView()
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
