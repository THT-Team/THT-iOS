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
}
