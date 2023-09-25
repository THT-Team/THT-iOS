//
//  MainView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

import RxSwift
import SnapKit

final class MainView: TFBaseView {
  
  lazy var backgroundView: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 15
    v.backgroundColor = FallingAsset.Color.dimColor.color.withAlphaComponent(0.5)
    return v
  }()
  
  lazy var timerView = CardTimerView()
  
  lazy var progressView = CardProgressView()

  override func layoutSubviews() {
    self.backgroundColor = .systemGray
  }

  override func makeUI() {
    self.addSubview(backgroundView)
    
    backgroundView.addSubviews([
      timerView,
      progressView
    ])
    
    backgroundView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
    
    timerView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(9)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(22)
      $0.height.equalTo(22)
    }
    
    progressView.snp.makeConstraints {
      $0.leading.equalTo(timerView.snp.trailing).offset(9)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(6)
    }
  }

  func dotPosition(progress: Double, rect: CGRect) -> CGPoint {
    var progress = round(progress * 100) / 100
//    if progress > 0.95 || progress < -0.05 { progress = 0.95 }
    let range: Range<Double> = -0.05..<1
    if !(range ~= progress) { progress = 0.95 }
    let radius = CGFloat(22 / 2 - 2 / 2)
    let angle = 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2
    let dotX = radius * cos(angle + 0.3)
    let dotY = radius * sin(angle + 0.3)

    let point = CGPoint(x: dotX, y: dotY)

    return CGPoint(
      x: rect.midX + point.x,
      y: rect.midY + point.y
    )
  }
}

extension Reactive where Base: MainView {
  var timeState: Binder<MainViewModel.TimeState> {
    return Binder(self.base) { (base, state) in
      base.timerView.timerLabel.textColor = state.color.color
      base.timerView.dotLayer.strokeColor = state.color.color.cgColor
      base.timerView.dotLayer.fillColor = state.color.color.cgColor
      base.timerView.strokeLayer.strokeColor = state.color.color.cgColor
      base.progressView.progressBarColor = state.color.color

      base.timerView.trackLayer.strokeColor = state.fillColor.color.cgColor

      base.timerView.dotLayer.isHidden = state.isDotHidden

      base.timerView.dotLayer.position = base.dotPosition(progress: state.getProgress, rect: base.timerView.bounds)

      base.timerView.timerLabel.text = state.getText

      let strokeEnd = round(CGFloat(state.getProgress) * 100) / 100
      base.timerView.strokeLayer.strokeEnd = strokeEnd

      base.progressView.progress = CGFloat(state.getProgress)
    }
  }
}
