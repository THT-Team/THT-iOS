//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

open class TFBaseView: UIView {
  private var dimView: UIView?
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
	
	@available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func showDimView(
    frame: CGRect = UIWindow.keyWindow?.frame ?? .zero,
    dimColor: UIColor = DSKitAsset.Color.DimColor.default.color) {

    if self.dimView == nil {
      let dimView = createDimView(dimColor: dimColor)
      self.addSubviews(dimView)
      self.dimView = dimView
      self.dimView?.frame = frame
    }

    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.dimView?.isHidden = false
    }
  }
  
  open func makeUI() {}
  
  public func hiddenDimView() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.dimView?.isHidden = true
      }
    }
  }

  private func createDimView(dimColor: UIColor) -> UIView {
    let view = UIView()
    view.backgroundColor = dimColor
    return view
  }
}
