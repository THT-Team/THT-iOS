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
    var progress = progress
    // progress가 -0.05미만 혹은 1이상은 점(dot)을 0초에 위치시키기 위함
    let strokeRange: Range<Double> = -0.05..<1
    if !(strokeRange ~= progress) { progress = 0.95 }
    let radius = CGFloat(rect.height / 2 - timerView.strokeLayer.lineWidth / 2)
    let angle = 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2
    let dotX = radius * cos(angle + 0.35)
    let dotY = radius * sin(angle + 0.35)
    
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
      base.timerView.trackLayer.strokeColor = state.fillColor.color.cgColor
      base.timerView.strokeLayer.strokeColor = state.color.color.cgColor
      base.timerView.dotLayer.strokeColor = state.color.color.cgColor
      base.timerView.dotLayer.fillColor = state.color.color.cgColor
      base.timerView.timerLabel.textColor = state.color.color
      base.progressView.progressBarColor = state.color.color
      
      base.timerView.dotLayer.isHidden = state.isDotHidden
      
      base.timerView.timerLabel.text = state.getText
      
      base.progressView.progress = CGFloat(state.getProgress)
      
      // TimerView Animation은 소수점 둘째 자리까지 표시해야 오차가 발생하지 않음
      let strokeEnd = round(CGFloat(state.getProgress) * 100) / 100
      base.timerView.dotLayer.position = base.dotPosition(progress: strokeEnd, rect: base.timerView.bounds)
      
      base.timerView.strokeLayer.strokeEnd = strokeEnd
    }
  }
}
