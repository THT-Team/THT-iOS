//
//  PauseView.swift
//  Falling
//
//  Created by SeungMin on 1/31/24.
//

import UIKit

import DSKit

open class PauseView: TFBaseView {
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 32
    return stackView
  }()
  
  lazy var ImageContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.pauseDim.color
    view.layer.cornerRadius = 31
    return view
  }()
  
  private lazy var pauseImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.pause.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  lazy var titleLabel: UILabel = {
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
    self.backgroundColor = DSKitAsset.Color.DimColor.pauseDim.color
    
    self.addSubview(stackView)
    
    stackView.snp.makeConstraints {
      $0.center.equalToSuperview().inset(5)
    }
    
    stackView.addArrangedSubviews([
      ImageContainerView,
      titleLabel
    ])

    ImageContainerView.addSubview(pauseImageView)
    
    ImageContainerView.snp.makeConstraints {
      $0.width.height.equalTo(62)
    }
    
    pauseImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
      
    stackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }

  public func showBlurView() {
    stackView.isHidden = true
    self.isHidden = false
  }

  public func hide() {
    self.isHidden = true
  }

  public func showPauseView() {
    stackView.isHidden = false
    self.isHidden = false
  }
}

extension Reactive where Base: PauseView {
  var isDimViewHidden: Binder<Bool> {
    return Binder(self.base) { (base, isHidden) in
      isHidden ? base.hide() : base.showBlurView()
    }
  }
}
