//
//  UIBarButtonItem+Util.swift
//  DSKit
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

public extension UIBarButtonItem {
  static let noti = UIBarButtonItem(image: DSKitAsset.Image.Icons.bell.image, style: .plain, target: nil, action: nil)
  static let backButton = UIBarButtonItem(image: DSKitAsset.Image.Icons.chevron.image, style: .plain, target: nil, action: nil)
  static let report = UIBarButtonItem(
    image: DSKitAsset.Image.Icons.report.image,
    style: .plain,
    target: nil, action: nil)
  static let exit = UIBarButtonItem(
      image: DSKitAsset.Image.Icons.logOut.image,
      style: .plain,
      target: nil, action: nil)
}

