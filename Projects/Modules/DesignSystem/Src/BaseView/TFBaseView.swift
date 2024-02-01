//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

open class TFBaseView: UIView {
  private let dimView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.default.color
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
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addSubview(self.dimView)
      UIView.animate(withDuration: 0.0) {
        self.dimView.backgroundColor = DSKitAsset.Color.DimColor.default.color
      }
    }
  }
  
  public func hiddenDimView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.0) { [weak self] in
        guard let self = self else { return }
        self.dimView.backgroundColor = DSKitAsset.Color.clear.color
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.dimView.removeFromSuperview()
      }
    }
  }
}
