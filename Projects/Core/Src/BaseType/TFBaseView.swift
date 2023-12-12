//
//  TFBaseView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

open class TFBaseView: UIView {

  override public init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Set up configuration of view and add subviews
  open func makeUI() { }
}
