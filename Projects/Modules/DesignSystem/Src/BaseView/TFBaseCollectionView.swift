//
//  TFBaseCollectionView.swift
//  DSKit
//
//  Created by SeungMin on 3/1/24.
//

import UIKit

open class TFBaseCollectionView: UICollectionView {
  private let dimView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.default.color
    return view
  }()
  
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
  
  open func makeUI() {}
  
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
