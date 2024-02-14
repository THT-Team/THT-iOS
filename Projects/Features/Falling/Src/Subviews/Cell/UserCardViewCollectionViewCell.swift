//
//  UserCardViewCollectionViewCell.swift
//  DSKit
//
//  Created by SeungMin on 1/31/24.
//

import UIKit

import DSKit

open class UserCardViewCollectionViewCell: TFBaseCollectionViewCell {
  let cellFrame = CGRect(
    x: 0,
    y: 0,
    width: (UIWindow.keyWindow?.bounds.width ?? .zero) - 32,
    height: ((UIWindow.keyWindow?.bounds.width ?? .zero) - 32) * 1.64
  )
  
  private lazy var dimView: UIView = {
    let view = UIView(frame: cellFrame)
    view.layer.cornerRadius = 20
    return view
  }()
  
  public func showDimView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addSubview(dimView)
      UIView.animate(withDuration: 0.0) {
        self.dimView.backgroundColor = DSKitAsset.Color.DimColor.default.color
      }
    }
  }
  
  public func hiddenDimView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.0) {
        self.dimView.backgroundColor = DSKitAsset.Color.clear.color
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.dimView.removeFromSuperview()
      }
    }
  }
}
