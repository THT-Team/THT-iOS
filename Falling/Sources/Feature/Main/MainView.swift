//
//  MainView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

final class MainView: TFBaseView {
  
  let progressContainerView: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 15
    v.backgroundColor = FallingAsset.Color.dimColor.color.withAlphaComponent(0.5)
    return v
  }()
  
  let timerLabel: UILabel = {
    let l = UILabel()
    l.text = "-"
    l.font = .thtCaption1M
    l.textAlignment = .center
    l.textColor = FallingAsset.Color.neutral300.color
    l.backgroundColor = FallingAsset.Color.unSelected.color
    l.layer.borderWidth = 2
    l.layer.cornerRadius = 10
    l.layer.borderColor = FallingAsset.Color.neutral300.color.cgColor
    l.layer.masksToBounds = true
    return l
  }()
  
  let progressView: UIProgressView = {
    let v = UIProgressView()
    v.layer.cornerRadius = 3
    v.backgroundColor = FallingAsset.Color.neutral600.color
    return v
  }()
  
  //  override func layoutSubviews() {
  //    super.layoutSubviews()
  //
  //    // 디바이스의 너비에 따라 conerRadius를 동적 지정
  //    let width = self.frame.width
  //
  //    progressBarContainerView.layer.cornerRadius = width / 10
  //    progressBarBackgoundView.layer.cornerRadius = width / 60
  //    progressBarView.layer.cornerRadius = width / 60
  //  }
  
  override func makeUI() {
    self.backgroundColor = .systemGray
    self.addSubview(progressContainerView)
    
    progressContainerView.addSubviews([
      timerLabel,
      progressView
    ])
    
    progressContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().inset(12)
      $0.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
    
    timerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(9)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(22)
      $0.height.equalTo(22)
    }
    
    progressView.snp.makeConstraints {
      $0.leading.equalTo(timerLabel.snp.trailing).offset(9)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(6)
    }
  }
}
