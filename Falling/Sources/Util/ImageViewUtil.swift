//
//  ImageViewUtil.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/14.
//

import UIKit

import Kingfisher

extension UIImageView {
  func setResource(_ resource: URL) {
    self.kf.setImage(
      with: resource,
      placeholder: nil,
      options: [
        .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 300))),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage
      ]
    )
  }
}
