//
//  SuccessCertificationView.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/15.
//

import UIKit

import Lottie

public final class SuccessCertificationView: UIView {

  private lazy var backCardView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
    $0.backgroundColor = DSKitAsset.Color.neutral600.color
  }

  private lazy var animationView = LottieAnimationView(animation: AnimationAsset.authSuccess.animation)

  private lazy var titleLabel = UILabel().then {
    $0.font = .thtH2B
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "핸드폰 번호 인증 완료"
  }

  public init() {
    super.init(frame: .zero)
    self.makeUI()
  }

  func makeUI() {
    self.animationView.contentMode = .scaleAspectFill
//    self.backgroundColor = DSKitAsset.Color.DimColor.signUpDim.color

    self.addSubview(backCardView)

    [animationView, titleLabel]
      .forEach { backCardView.addSubview($0) }

    backCardView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    animationView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(69)
      $0.height.equalToSuperview().multipliedBy(0.470)
      $0.width.equalToSuperview().multipliedBy(0.852)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(animationView.snp.bottom).offset(34)
      $0.centerX.equalToSuperview()
    }
  }

  public func animationPlay(completion: @escaping () -> Void) {
    self.animationView.play { _ in completion() }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
