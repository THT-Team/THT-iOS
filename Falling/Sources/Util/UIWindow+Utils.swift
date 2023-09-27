//
//  UIWindow+Utils.swift
//  Falling
//
//  Created by SeungMin on 2023/09/27.
//

import UIKit

extension UIWindow {
  
  static var keyWindow: UIWindow? {
    return UIApplication
      .shared
      .connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .last
  }
  
  static var safeAreaInsetBottom: CGFloat {
    return (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0)
  }
}
