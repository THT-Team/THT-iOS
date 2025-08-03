//
//  UIBarButtonItem+Util.swift
//  DSKit
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

public extension UIBarButtonItem {
  static let bling: UIBarButtonItem = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = DSKitAsset.Image.Icons.bling.image.resized(to: CGSize(width: 28, height: 28))
    return UIBarButtonItem(customView: imageView)
  }()
  
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
