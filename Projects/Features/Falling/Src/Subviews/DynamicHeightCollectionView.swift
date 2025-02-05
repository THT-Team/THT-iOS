//
//  DynamicHeightCollectionView.swift
//  Falling
//
//  Created by Kanghos on 2/6/25.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

  override var contentSize: CGSize {
    didSet {
      if oldValue.height != contentSize.height {
        invalidateIntrinsicContentSize()
      }
    }
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + 10)
  }
}
