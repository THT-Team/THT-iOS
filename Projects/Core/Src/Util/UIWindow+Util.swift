//
//  UIWindow+Util.swift
//  Core
//
//  Created by Kanghos on 2024/01/05.
//

import UIKit

public extension UIWindow {
  static var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .last
  }
}
