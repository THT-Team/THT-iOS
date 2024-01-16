//
//  UIStackView+addArrangedSubviews.swift
//  Falling
//
//  Created by SeungMin on 2023/09/17.
//

import UIKit

public extension UIStackView {

  public func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { self.addArrangedSubview($0) }
  }
}
