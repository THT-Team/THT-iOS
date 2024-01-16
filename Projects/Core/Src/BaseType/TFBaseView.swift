//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

import DSKit

open class TFBaseView: UIView {
  public lazy var dimView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Set up configuration of view and add subviews
  open func makeUI() { }
  
  public func showDimView(frame: CGRect = UIWindow.keyWindow?.frame ?? .zero) {
    dimView.frame = frame
    DispatchQueue.main.async {
      self.addSubview(self.dimView)
      UIView.animate(withDuration: 0.0) {
        self.dimView.backgroundColor =      DSKitAsset.Color.cardShadow.color.withAlphaComponent(0.7)
      }
    }
  }
  
  public func hiddenDimView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.0) { [weak self] in
        self?.dimView.backgroundColor = .clear
      } completion: { [weak self] _ in
        self?.dimView.removeFromSuperview()
      }
    }
  }
}
