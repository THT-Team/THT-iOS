//
//  MyPageTagCollectionView.swift
//  MyPage
//
//  Created by Kanghos on 6/11/24.
//

import UIKit

class MyPageTagCollectionView: UICollectionView {

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
