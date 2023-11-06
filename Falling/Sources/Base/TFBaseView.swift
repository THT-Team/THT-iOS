//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

class TFBaseView: UIView {
  lazy var dimView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Set up configuration of view and add subviews
  func makeUI() { }
    
  func showDimView(frame: CGRect = UIWindow.keyWindow?.frame ?? .zero) {
    dimView.frame = frame
    DispatchQueue.main.async {
      self.addSubview(self.dimView)
      UIView.animate(withDuration: 0.0) {
        self.dimView.backgroundColor =      FallingAsset.Color.cardShadow.color.withAlphaComponent(0.7)
      }
    }
  }
  
  func hiddenDimView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.0) { [weak self] in
        self?.dimView.backgroundColor = .clear
      } completion: { [weak self] _ in
        self?.dimView.removeFromSuperview()
      }
    }
  }
}
