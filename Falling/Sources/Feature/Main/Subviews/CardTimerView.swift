//
//  CardTimerView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/19.
//

import UIKit

final class CardTimerView: TFBaseView {
    
  lazy var timerLabel: UILabel = {
    let l = UILabel()
    l.font = .thtCaption1M
    l.textAlignment = .center
    l.backgroundColor = FallingAsset.Color.unSelected.color
    l.layer.cornerRadius = 16 / 2
    l.clipsToBounds = true
    return l
  }()
  
  lazy var dotLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 1
    layer.fillColor = FallingAsset.Color.clear.color.cgColor
    return layer
  }()
  
  lazy var trackLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.fillColor = FallingAsset.Color.clear.color.cgColor
    return layer
  }()
  
  lazy var strokeLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.fillColor = FallingAsset.Color.clear.color.cgColor
    return layer
  }()
  
  override func makeUI() {
    layer.addSublayer(trackLayer)
    layer.addSublayer(strokeLayer)
    layer.addSublayer(dotLayer)
    
    self.addSubview(timerLabel)
    timerLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.equalTo(16)
      $0.height.equalTo(16)
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
}
