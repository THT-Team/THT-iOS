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
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.pauseTitle.color
    label.numberOfLines = 2
    label.setTextWithLineHeight(
      text: "무디 탐색을 일시정지했어요.\n다시 무디를 보고싶다면 더블 탭해주세요.",
      lineHeight: 19.6
    )
    return label
  }()
    
  open override func makeUI() {
    self.isHidden = true
    
    self.addSubview(blurView)
    self.blurView.contentView.addSubview(stackView)
    
    stackView.addArrangedSubviews([
      pauseView,
      titleLabel
    ])
    
    pauseView.snp.makeConstraints {
      $0.width.height.equalTo(62)
    }
    
    pauseView.addSubview(pauseImageView)
    
    pauseImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
      
    stackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
