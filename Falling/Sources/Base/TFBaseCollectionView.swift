//
//  TFBaseCollectionView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit

class TFBaseCollectionViewCell: UICollectionViewCell {

  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Set up configuration of view and add subviews
  func makeUI() { }
}
