//
//  DimViewManger.swift
//  Falling
//
//  Created by SeungMin on 2023/10/20.
//

import UIKit

final class DimViewManager {
  
  static let shared = DimViewManager()
  
  private lazy var dimView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private init() { }
  
  func showDimView(frame: CGRect = UIWindow.keyWindow?.frame ?? .zero,
                   targetView: UIView) {
    dimView.frame = frame
    DispatchQueue.main.async {
      targetView.addSubview(self.dimView)
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
