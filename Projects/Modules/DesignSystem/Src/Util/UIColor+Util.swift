//
//  UIColor+Util.swift
//  DSKit
//
//  Created by SeungMin on 4/20/24.
//

import UIKit

extension UIColor {
  /// Convert color to image
  func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}
