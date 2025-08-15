//
//  CardTimeView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit

final class CardTimeView: TFBaseView {
  lazy var containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.backgroundColor = DSKitAsset.Color.DimColor.timerDim.color.withAlphaComponent(0.5)
    return view
  }()
  
  lazy var timerView = CardCircleTimerView()
  
  lazy var progressView = CardProgressView()
  
  override func makeUI() {
    isUserInteractionEnabled = false
    
    self.addSubview(containerView)
    containerView.addSubviews([timerView, progressView])
    
    self.containerView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
    
    self.timerView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(9)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(22)
      $0.height.equalTo(22)
    }
    
    self.progressView.snp.makeConstraints {
      $0.leading.equalTo(timerView.snp.trailing).offset(9)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(6)
    }
  }

  func bind(_ timeState: TimeState) {
    timerView.trackLayer.strokeColor = timeState.trackLayerStrokeColor.color.cgColor
    timerView.strokeLayer.strokeColor = timeState.timerTintColor.color.cgColor
    timerView.dotLayer.strokeColor = timeState.timerTintColor.color.cgColor
    timerView.dotLayer.fillColor = timeState.timerTintColor.color.cgColor
    timerView.timerLabel.textColor = timeState.timerTintColor.color
    progressView.progressBarColor = timeState.progressBarColor.color

    timerView.dotLayer.isHidden = timeState.isDotHidden

    timerView.timerLabel.text = timeState.getText

    progressView.progress = timeState.getProgress

    // 소수점 3번 째자리까지 표시하면 오차가 발생해서 2번 째자리까지만 표시
    let strokeEnd = round(timeState.getProgress * 100) / 100

    timerView.dotLayer.position = dotPosition(progress: strokeEnd, rect: timerView.bounds, lineWidth: timerView.strokeLayer.lineWidth)

    timerView.strokeLayer.strokeEnd = strokeEnd
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

  func showTimerGradient() {
    progressView.toggleGradientLayer(false)
    timerView.timerLabel.isHidden = true
    timerView.toggleCircleLayer(false)
  }

  func hideTimerGradient() {
    progressView.toggleGradientLayer(true)
    timerView.timerLabel.isHidden = false
    timerView.toggleCircleLayer(true)
  }
}
