//
//  UIView+addSubviews.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: [UIView]) {
    views.forEach { self.addSubview($0) }
  }
}
