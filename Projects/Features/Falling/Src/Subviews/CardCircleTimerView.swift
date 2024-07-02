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
  private var gradientLayer: CAGradientLayer?

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
    imageView.isHidden = true
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

    self.addSubview(likeImageView)

    likeImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.equalTo(8)
      $0.height.equalTo(7)
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

  func toggleCircleLayer(_ isHidden: Bool) {
    addGradientLayer()

    self.gradientLayer?.isHidden = isHidden
    self.likeImageView.isHidden = isHidden
  }

  private func addGradientLayer() {
    if let layer = gradientLayer {
      return
    } else {
      let circleLayer = createGradientLayer()
      self.gradientLayer = circleLayer
      layer.addSublayer(circleLayer)
    }
  }

  private func createGradientLayer() -> CAGradientLayer {


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

    return gradientLayer
  }
  
  func bind(_ timeState: TimeState) {
    trackLayer.strokeColor = timeState.trackLayerStrokeColor.color.cgColor
    strokeLayer.strokeColor = timeState.timerTintColor.color.cgColor
    dotLayer.strokeColor = timeState.timerTintColor.color.cgColor
    dotLayer.fillColor = timeState.timerTintColor.color.cgColor
    timerLabel.textColor = timeState.timerTintColor.color
    
    
    dotLayer.isHidden = timeState.isDotHidden
    
    timerLabel.text = timeState.getText
    
    // 소수점 3번 째자리까지 표시하면 오차가 발생해서 2번 째자리까지만 표시
    let strokeEnd = round(timeState.getProgress * 100) / 100
    
    dotLayer.position = dotPosition(progress: strokeEnd, rect: bounds, lineWidth: strokeLayer.lineWidth)
    
    strokeLayer.strokeEnd = strokeEnd
  }
  
  private func dotPosition(progress: CGFloat, rect: CGRect, lineWidth: CGFloat) -> CGPoint {
    let radius = CGFloat(rect.height / 2 - lineWidth / 2)
      
    // 3 / 2 pi(정점 각도) -> - 1 / 2 pi(정점)
    var angle = 2 * CGFloat.pi * progress - CGFloat.pi / 2 + CGFloat.pi / 10 // 두 원의 중점과 원점이 이루는 각도를 18도로 가정
    if angle <= -CGFloat.pi / 2 || CGFloat.pi * 1.5 <= angle  {
      angle = -CGFloat.pi / 2 // 정점 각도
    }
    
    let dotX = radius * cos(angle)
    let dotY = radius * sin(angle)
    
    let point = CGPoint(x: dotX, y: dotY)
    
    return CGPoint(
      x: rect.midX + point.x,
      y: rect.midY + point.y
    )
  }
}
