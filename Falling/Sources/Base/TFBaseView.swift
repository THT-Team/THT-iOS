//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

class TFBaseView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    bindConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Add subviews
  func setup() { }
  
  /// Set up Constraints
  func bindConstraints() { }
}
