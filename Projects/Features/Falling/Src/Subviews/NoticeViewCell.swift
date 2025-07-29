//
//  NoticeViewCell.swift
//  Falling
//
//  Created by SeungMin on 12/1/24.
//

import UIKit

import DSKit
import Lottie

final class NoticeViewCell: TFBaseCollectionViewCell {
  private let backgroundGradientLayer = CAGradientLayer()
  private let borderGradientLayer = CAGradientLayer()
  private let maskLayer = CAShapeLayer()
  
  var Action: Action = .find
  
  private let cardTimeView = CardTimeView()

  private let contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 0
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .thtH4Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = .thtP1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral300.color
    return label
  }()
  
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
//    button.setTitleColor(DSKitAsset.Color.neutral600.color, for: .normal)
//    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .selected)
    button.backgroundColor = DSKitAsset.Color.primary500.color
    button.layer.cornerRadius = 16
    button.clipsToBounds = true
    
    return button
  }()
  
  private let midView = UIView()
  
  private
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = 20
    clipsToBounds = true
    
    setupLayers()
    makeUI()
  }
  
  override func layoutSubviews() {
    layoutGradientLayers()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func makeUI() {
    addSubviews([
      cardTimeView,
      midView,
      contentStackView,
      submitButton
    ])
    
    contentStackView.addArrangedSubviews([
      imageView,
      titleLabel,
      subtitleLabel
    ])
    
    cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
    
    submitButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(66)
      $0.directionalHorizontalEdges.equalToSuperview().inset(39)
      $0.height.equalTo(52)
    }
  
    midView.snp.makeConstraints {
      $0.top.equalTo(cardTimeView.snp.bottom)
      $0.bottom.equalTo(submitButton.snp.top)
      $0.directionalHorizontalEdges.equalToSuperview()
    }
    
    contentStackView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(midView)
    }
    
    imageView.snp.makeConstraints {
      $0.height.equalTo(212)
    }
    
    contentStackView.setCustomSpacing(40, after: imageView)
    contentStackView.setCustomSpacing(2, after: titleLabel)
  }
  
  private func setupLayers() {
    backgroundGradientLayer.colors = [
      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color.cgColor,
      DSKitAsset.Color.DummyUserGradient.backgroundSecond.color.cgColor,
      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color.cgColor
    ]
    
    backgroundGradientLayer.locations = [0.0, 0.5, 1.0]
    
    backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    layer.addSublayer(backgroundGradientLayer)
    
    borderGradientLayer.colors = [
      DSKitAsset.Color.DummyUserGradient.borderFirst.color.cgColor,
      DSKitAsset.Color.DummyUserGradient.borderSecond.color.cgColor
    ]
        
    borderGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    borderGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    borderGradientLayer.mask = maskLayer
    layer.addSublayer(borderGradientLayer)
  }
  
  private func layoutGradientLayers() {
    backgroundGradientLayer.frame = bounds
    borderGradientLayer.frame = bounds
    
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)

    maskLayer.path = path.cgPath
    maskLayer.lineWidth = 1
    maskLayer.fillColor = UIColor.clear.cgColor
    maskLayer.strokeColor = UIColor.orange.cgColor
  }
  
  func configure(type: NoticeViewCell.Action) {
    imageView.image = type.image
    titleLabel.text = type.title
    
    subtitleLabel.text = type.subtitle
    submitButton.setAttributedTitle(
      NSAttributedString(
        string: type.buttonTitle,
        attributes: [
          .font: UIFont.thtH5B,
          .foregroundColor: DSKitAsset.Color.neutral600.color
        ]
      ),
      for: .normal
    )
    
    submitButton.setAttributedTitle(
      NSAttributedString(
        string: type.buttonTitle,
        attributes: [
          .font: UIFont.thtH5B,
          .foregroundColor: DSKitAsset.Color.neutral50.color
        ]
      ),
      for: .selected
    )
  }
}

extension NoticeViewCell {
  enum Action: String {
    case allMet
    case find
    case selectedFirst
    
    var image: UIImage {
      switch self {
      case .allMet:
        return DSKitAsset.Image.Icons.allMet.image
      case .find:
        return DSKitAsset.Image.Icons.find.image
      case .selectedFirst:
        return DSKitAsset.Image.Icons.selectedFirst.image
      }
    }
    
    var title: String {
      switch self {
      case .allMet:
        "무디를 모두 만나봤어요!"
      case .find:
        "무디를 찾았어요!"
      case .selectedFirst:
        "주제어를 가장 먼저 선택했어요!"
      }
    }
    
    var subtitle: String {
      switch self {
      case .allMet:
        "아직 무디가 들어오고있어요."
      case .find:
        "같은 주제로 이야기할 무디를 만나볼까요?"
      case .selectedFirst:
        "아직 무디가 들어오고있어요."
      }
    }
    
    var buttonTitle: String {
      switch self {
      case .allMet, .selectedFirst:
        "기다리는 무디 조회하기"
      case .find:
        "시작하기"
      }
    }
  }
}
