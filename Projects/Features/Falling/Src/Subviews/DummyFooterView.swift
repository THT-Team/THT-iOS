//
//  DummyFooterView.swift
//  Falling
//
//  Created by SeungMin on 5/26/24.
//

import UIKit

import DSKit

final class DummyFooterView: UICollectionReusableView {
  private lazy var cardTimeView = CardTimeView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)

    configureUI()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    layer.borderWidth = 1
    layer.cornerRadius = 20
    clipsToBounds = true
//    backgroundColor = .blue
//    layer.borderColor = UIColor.orange.cgColor
    
    addGradientBackground()
    addGradientBorder()
  }
  
  private func makeUI() {
    addSubview(cardTimeView)
    
    cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
  }
  
  private func addGradientBackground() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    
    gradientLayer.colors = [
      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color,
      DSKitAsset.Color.DummyUserGradient.backgroundSecond.color,
      DSKitAsset.Color.DummyUserGradient.backgroundFirst.color
    ]
    
    gradientLayer.locations = [0.0, 0.5, 1.0]
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
//    layer.addSublayer(gradientLayer)
    
    layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func addGradientBorder() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    
    gradientLayer.colors = [
      DSKitAsset.Color.DummyUserGradient.borderFirst.color,
      DSKitAsset.Color.DummyUserGradient.borderSecond.color
    ]
    
//    gradientLayer.locations = [0.0, 0.5, 1.0]
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
    let shapeLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    shapeLayer.path = path.cgPath
    shapeLayer.lineWidth = 1
    shapeLayer.fillColor = DSKitAsset.Color.LikeGradient.gradientFirst.color.cgColor
    shapeLayer.strokeColor = DSKitAsset.Color.LikeGradient.gradientFirst.color.cgColor
    
    gradientLayer.mask = shapeLayer
    
//    layer.addSublayer(gradientLayer)
    
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
