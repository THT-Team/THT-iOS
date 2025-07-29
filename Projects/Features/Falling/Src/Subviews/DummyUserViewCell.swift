//
//  DummyUserViewCell.swift
//  Falling
//
//  Created by SeungMin on 7/29/25.
//

import UIKit

import DSKit

final class DummyUserViewCell: TFBaseCollectionViewCell {
  private let backgroundGradientLayer = CAGradientLayer()
  private let borderGradientLayer = CAGradientLayer()
  private let maskLayer = CAShapeLayer()
  
  private let dummyImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleToFill
    image.clipsToBounds = true
    return image
  }()
  
  private let cardTimeView = CardTimeView()
  
  private let blurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .dark)
    
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.layer.cornerRadius = 20
    visualEffectView.clipsToBounds = true
    visualEffectView.backgroundColor = DSKitAsset.Color.blur.color
    // TODO: alpha값은 더 투명하게 보이게 하기 위해 임의로 설정
    visualEffectView.alpha = 0.95
    return visualEffectView
  }()
  
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 32
    return stackView
  }()
  
  let topicLabel: TFPaddingLabel = {
    let label = TFPaddingLabel(
      padding: UIEdgeInsets(
        top: 5,
        left: 14,
        bottom: 5,
        right: 14
      )
    )
    label.text = "MY TOPIC"
    label.font = UIFont.thtSubTitle1Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.primary500.color
    label.layer.borderWidth = 1.2
    label.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    label.layer.cornerRadius = 14
    return label
  }()
  
  private let mindImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.mind140x140.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let labelStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 2
    return stack
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtH4Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.setTextWithLineHeight(
      text: "주로 혼자 어떻게 시간을 보내나요?",
      lineHeight: 24.7
    )
    return label
  }()
  
  let subTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral300.color
    label.setTextWithLineHeight(
      text: "버튼을 눌러 시작하기",
      lineHeight: 19.6
    )
    return label
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
    button.setAttributedTitle(
      NSAttributedString(
        string: "시작하기",
        attributes: [
          .font: UIFont.thtH5B,
          .foregroundColor: DSKitAsset.Color.neutral600.color
        ]
      ),
      for: .normal
    )
    
    button.setAttributedTitle(
      NSAttributedString(
        string: "시작하기",
        attributes: [
          .font: UIFont.thtH5B,
          .foregroundColor: DSKitAsset.Color.neutral50.color
        ]
      ),
      for: .selected
    )
    button.backgroundColor = DSKitAsset.Color.primary500.color
    button.layer.cornerRadius = 16
    button.clipsToBounds = true
    
    return button
  }()
    
  override init(frame: CGRect) {
    super.init(frame: .zero)
    layer.cornerRadius = 20
    clipsToBounds = true
    
//    makeUserCardView()
//    setupLayers()
//    makeUI()
  }
  
//  override func layoutSubviews() {
//    blurView.frame = bounds
//    layoutGradientLayers()
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  private func makeUserCardView() {
//    addSubviews([dummyImageView, cardTimeView])
//    
//    dummyImageView.snp.makeConstraints {
//      $0.edges.equalToSuperview()
//    }
//    
//    cardTimeView.snp.makeConstraints {
//      $0.top.leading.trailing.equalToSuperview().inset(12)
//      $0.height.equalTo(32)
//    }
//  }
//  
//  private func setupLayers() {
//    backgroundGradientLayer.colors = [
//      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color.cgColor,
//      DSKitAsset.Color.DummyUserGradient.backgroundSecond.color.cgColor,
//      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color.cgColor
//    ]
//    
//    backgroundGradientLayer.locations = [0.0, 0.5, 1.0]
//    
//    backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//    backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//    layer.addSublayer(backgroundGradientLayer)
//    
//    borderGradientLayer.colors = [
//      DSKitAsset.Color.DummyUserGradient.borderFirst.color.cgColor,
//      DSKitAsset.Color.DummyUserGradient.borderSecond.color.cgColor
//    ]
//        
//    borderGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//    borderGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//    borderGradientLayer.mask = maskLayer
//    layer.addSublayer(borderGradientLayer)
//  }
//  
//  private func layoutGradientLayers() {
//    backgroundGradientLayer.frame = bounds
//    borderGradientLayer.frame = bounds
//    
//    let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
//
//    maskLayer.path = path.cgPath
//    maskLayer.lineWidth = 1
//    maskLayer.fillColor = UIColor.clear.cgColor
//    maskLayer.strokeColor = UIColor.orange.cgColor
//  }
  
  override func makeUI() {
//    addSubview(blurView)
//    blurView.contentView.addSubviews([containerStackView, submitButton])
    
    addSubviews([dummyImageView, containerStackView, submitButton])
    
    containerStackView.addArrangedSubviews([topicLabel, mindImageView, labelStackView])
    
    labelStackView.addArrangedSubviews([titleLabel, subTitleLabel])
    
//    blurView.snp.makeConstraints {
//      $0.edges.equalToSuperview()
//    }
    
    dummyImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    containerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(129)
      $0.centerX.equalToSuperview()
    }
    
    mindImageView.snp.makeConstraints {
      $0.width.height.equalTo(140)
    }
    
    submitButton.snp.makeConstraints {
      $0.directionalHorizontalEdges.equalToSuperview().inset(39)
      $0.bottom.equalToSuperview().inset(42)
      $0.height.equalTo(52)
    }
  }
  
  func configure(dummyImage: UIImage) {
    dummyImageView.image = dummyImage
  }
}
