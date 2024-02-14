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
    let effect = UIBlurEffect(style: .dark)
    
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.frame = bounds
    visualEffectView.layer.cornerRadius = 20
    visualEffectView.clipsToBounds = true
    visualEffectView.backgroundColor = DSKitAsset.Color.blur.color
    // TODO: alpha값은 더 투명하게 보이게 하기 위해 임의로 설정
    visualEffectView.alpha = 0.95
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
  
  private lazy var pauseView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.pauseDim.color
    view.layer.cornerRadius = 31
    return view
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
    label.font = UIFont.thtP1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.pauseTitle.color
    label.numberOfLines = 2
    label.setTextWithLineHeight(
      text: "대화가 잘 통하는 무디를\n찾을 준비가 됐나요?",
      lineHeight: 19.8
    )
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
      pauseView,
      labelStackView
    ])
    
    pauseView.snp.makeConstraints {
      $0.width.height.equalTo(62)
    }
    
    pauseView.addSubview(pauseImageView)
    
    pauseImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    resumeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20)
    }
    
    labelStackView.addArrangedSubviews([
      titleLabel
    ])
    
    stackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
