//
//  UIStackView+addArrangedSubviews.swift
//  Falling
//
//  Created by SeungMin on 2023/09/17.
//

import UIKit

extension UIStackView {
  
  func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { self.addArrangedSubview($0) }
  }
}
