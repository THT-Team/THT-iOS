//
//  UIColor+Util.swift
//  DSKit
//
//  Created by SeungMin on 4/20/24.
//

import UIKit

public extension UIColor {
  /// Convert color to image
  func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
  func adjusted(brightness: CGFloat) -> UIColor {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightnessValue: CGFloat = 0
    var alpha: CGFloat = 0

    if self.getHue(&hue, saturation: &saturation, brightness: &brightnessValue, alpha: &alpha) {
      return UIColor(hue: hue, saturation: saturation, brightness: brightnessValue * brightness, alpha: alpha)
    } else {
      return self
    }
  }
}
