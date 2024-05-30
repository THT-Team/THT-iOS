//
//  CardCircleTimerView.swift
//  Falling
//
//  Created by SeungMin on 1/12/24.
//

import UIKit

import Core
import DSKit

final class CardCircleTimerView: TFBaseView {
  lazy var timerLabel: UILabel = {
    let label = UILabel()
    label.font = .thtCaption1M
    label.textAlignment = .center
    label.backgroundColor = DSKitAsset.Color.unSelected.color
    label.layer.cornerRadius = 16 / 2
    label.clipsToBounds = true
    return label
  }()
  
  lazy var trackLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.fillColor = DSKitAsset.Color.clear.color.cgColor
    layer.strokeColor = DSKitAsset.Color.neutral300.color.cgColor
    return layer
  }()
  
  lazy var strokeLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.fillColor = DSKitAsset.Color.clear.color.cgColor
    return layer
  }()
  
  lazy var dotLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 1
    layer.fillColor = DSKitAsset.Color.clear.color.cgColor
    return layer
  }()
  
  private lazy var likeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.cardLike.image.withTintColor(DSKitAsset.Color.error.color)
    return imageView
  }()
  
  override func makeUI() {
    layer.addSublayer(trackLayer)
    layer.addSublayer(strokeLayer)
    layer.addSublayer(dotLayer)
    
    self.addSubview(timerLabel)
    timerLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.height.equalTo(16)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dotLayer.frame = bounds
    trackLayer.frame = bounds
    strokeLayer.frame = bounds
    updatePath()
  }
  
  private func updatePath() {
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = bounds.height / 2 - strokeLayer.lineWidth / 2
    let circularPath = UIBezierPath(arcCenter: center,
                                    radius: radius,
                                    startAngle: -CGFloat.pi / 2,
                                    endAngle: 3 * CGFloat.pi / 2,
                                    clockwise: true)
    trackLayer.path = circularPath.cgPath
    strokeLayer.path = circularPath.cgPath
    
    let dotPath = UIBezierPath(arcCenter: center,
                               radius: strokeLayer.lineWidth / 2,
                               startAngle: -CGFloat.pi / 2,
                               endAngle: 3 * CGFloat.pi / 2,
                               clockwise: true)
    dotLayer.path = dotPath.cgPath
  }
  
  func addGradientLayer() {
    self.addSubview(likeImageView)
    
    likeImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.equalTo(8)
      $0.height.equalTo(7)
    }
    
    let gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = self.bounds
    
    gradientLayer.colors = [
      DSKitAsset.Color.LikeGradient.gradientFirst.color.cgColor,
      DSKitAsset.Color.LikeGradient.gradientSecond.color.cgColor,
      DSKitAsset.Color.LikeGradient.gradientThird.color.cgColor
    ]
    
    gradientLayer.locations = [0.0, 0.5, 1.0]
    
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
    gradientLayer.mask = trackLayer
    
    layer.addSublayer(gradientLayer)
  }
}
