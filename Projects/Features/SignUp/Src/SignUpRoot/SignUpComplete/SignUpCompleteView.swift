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
    $0.font = .thtH2B
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  private lazy var conicGradient: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.type = .conic
    gradient.colors = [
      DSKitAsset.Color.primary500.color.cgColor,
      DSKitAsset.Color.thtOrange400.color.cgColor
    ]
    gradient.locations = [0]

    // startPoint: 원의 중심, endPoint: 첫 번째 색상과 마지막 색상이 결합되는 지점
    // (0,0)우측하단, (1,1)은 (0,0)에서 한바퀴 돌은 지점
    gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    return gradient
  }()

  private lazy var gradientView = UIView().then {
    $0.backgroundColor = .green
    $0.layer.addSublayer(conicGradient)
    $0.layer.cornerRadius = 32
    $0.clipsToBounds = true
  }

  lazy var descLabel = UILabel().then {
    $0.text = "폴링에 한 번 빠져 보시겠어요"
    $0.font = .thtSubTitle1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }

  lazy var imageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Test.test1.image
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
    $0.layer.borderColor = DSKitAsset.Color.neutral700.color.cgColor
    $0.layer.borderWidth = 10
  }

  lazy var nextBtn = CTAButton(btnTitle: "네, 좋아요", initialStatus: true)

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
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(76)
      $0.leading.trailing.equalToSuperview().inset(38)
    }

    descLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(38)
    }
    gradientView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(250)
    }

    imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(235)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(54)
    }

  }

  override func layoutSubviews() {
    super.layoutSubviews()
    conicGradient.frame = gradientView.bounds
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

