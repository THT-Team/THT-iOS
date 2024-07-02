//
//  TFBaseCollectionView.swift
//  DSKit
//
//  Created by SeungMin on 3/1/24.
//

import UIKit

import RxSwift

open class TFBaseCollectionView: UICollectionView {

  private var dimView: UIView?
  
  public func showDimView(frame: CGRect = UIWindow.keyWindow?.frame ?? .zero) {

    if self.dimView == nil {
      let dimView = createDimView()
      self.addSubviews(dimView)
      self.dimView = dimView
    }
    dimView?.frame = frame

    UIView.animate(withDuration: 0.3) {
      self.dimView?.alpha = 1
    }
  }
  
  open func makeUI() {}
  
  public func hiddenDimView() {
    if let dimView {
      DispatchQueue.main.async {
        UIView.animate(withDuration: 0.3) {
          dimView.alpha = 0
        }
      }
    }
  }

  private func createDimView() -> UIView {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.DimColor.default.color
    return view
  }
}
