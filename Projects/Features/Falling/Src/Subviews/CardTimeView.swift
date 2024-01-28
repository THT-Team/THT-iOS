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
}
