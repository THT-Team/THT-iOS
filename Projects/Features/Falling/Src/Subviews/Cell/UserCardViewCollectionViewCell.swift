//
//  UserCardViewCollectionViewCell.swift
//  DSKit
//
//  Created by SeungMin on 1/31/24.
//

import UIKit

import DSKit

open class UserCardViewCollectionViewCell: TFBaseCollectionViewCell {
  private let cellFrame = CGRect(
    x: 0,
    y: 0,
    width: (UIWindow.keyWindow?.bounds.width ?? .zero) - 32,
    height: ((UIWindow.keyWindow?.bounds.width ?? .zero) - 32) * 1.64
  )
  
  private lazy var dimView = UIView(frame: cellFrame)
  
  private lazy var pauseView = PauseView(frame: cellFrame)
  
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
  
  public func showPauseView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addSubview(pauseView)
      UIView.animate(withDuration: 0.0) {
        self.pauseView.backgroundColor = DSKitAsset.Color.blur.color
      }
    }
  }
  
  public func hiddenPauseView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.0) {
        self.pauseView.backgroundColor = DSKitAsset.Color.clear.color
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.pauseView.removeFromSuperview()
      }
    }
  }
}
