//
//  PauseView.swift
//  Falling
//
//  Created by SeungMin on 1/31/24.
//

import UIKit

import DSKit

open class PauseView: TFBaseView {
  private lazy var blurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .regular)
    
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.frame = bounds
    visualEffectView.layer.cornerRadius = 20
    visualEffectView.clipsToBounds = true
    visualEffectView.backgroundColor = DSKitAsset.Color.blur.color
    // TODO: alpha값은 더 투명하게 보이게 하기 위해 임의로 설정
    visualEffectView.alpha = 0.88
    return visualEffectView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 32
    return stackView
  }()
  
  private lazy var pauseImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.pause.image
    return imageView
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "잠시 쉬었다 가시겠어요?"
    label.font = UIFont.thtH4Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "저희가 잠시 홀드 해 놓을게요."
    label.font = UIFont.thtP1M
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  private lazy var resumeLabel: UILabel = {
    let label = UILabel()
    label.text = "더블탭으로 다시 시작하기"
    label.font = UIFont.thtP1M
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
    
  open override func makeUI() {
    self.isHidden = true
    
    self.addSubview(blurView)
    self.blurView.contentView.addSubview(stackView)
    self.blurView.contentView.addSubview(resumeLabel)
    
    stackView.addArrangedSubviews([
      pauseImageView,
      labelStackView
    ])
    
    pauseImageView.snp.makeConstraints {
      $0.width.height.equalTo(66)
    }
    resumeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20)
    }
    
    labelStackView.addArrangedSubviews([
      titleLabel,
      subTitleLabel
    ])
    
    stackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
//  public func show() {
//    UIView.animate(withDuration: 0.2) { [weak self] in
//      guard let self = self else { return }
//      self.isHidden = false
//    }
//  }
//  
//  public func hidden() {
//    UIView.animate(withDuration: 0.2) { [weak self] in
//      guard let self = self else { return }
//      self.isHidden = true
//    }
//  }
}
