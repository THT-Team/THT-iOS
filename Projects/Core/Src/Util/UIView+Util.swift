//
//  UIView+Util.swift
//  Core
//
//  Created by Kanghos on 2023/12/12.
//

import UIKit

public extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach { self.addSubview($0) }
  }

  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
 }
