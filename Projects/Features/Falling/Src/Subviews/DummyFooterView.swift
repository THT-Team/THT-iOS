//
//  DummyFooterView.swift
//  Falling
//
//  Created by SeungMin on 5/26/24.
//

import UIKit

import DSKit

final class DummyFooterView: UICollectionReusableView {
  private let backgroundGradientLayer = CAGradientLayer()
  private let borderGradientLayer = CAGradientLayer()
  private let maskLayer = CAShapeLayer()
  
  private lazy var cardTimeView = CardTimeView()
    
  override init(frame: CGRect) {
    super.init(frame: .zero)
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
  
  private func makeUI() {
    addSubview(cardTimeView)
    
    cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
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
}
