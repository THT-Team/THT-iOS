//
//  UserCardViewCollectionViewCell.swift
//  DSKit
//
//  Created by SeungMin on 1/31/24.
//

import UIKit

open class UserCardViewCollectionViewCell: TFBaseCollectionViewCell {
  private let userCardDimView: UIView = {
    let userCardWidth = (UIWindow.keyWindow?.bounds.width ?? .zero) - 32
    let view = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: userCardWidth,
        height: userCardWidth * 1.64
      )
    )
    view.layer.cornerRadius = 20
    return view
  }()
  
  public func showUserCardDimView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addSubviews(userCardDimView)
      print("DimView added!")
      UIView.animate(withDuration: 0.0) {
        self.userCardDimView.backgroundColor = DSKitAsset.Color.DimColor.default.color
      }
    }
  }
  
  public func hiddenUserCardDimView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.0) {
        self.userCardDimView.backgroundColor = DSKitAsset.Color.clear.color
      } completion: { [weak self] _ in
        guard let self = self else { return }
        print("Removed DimView!")
        self.userCardDimView.removeFromSuperview()
      }
    }
  }
}
