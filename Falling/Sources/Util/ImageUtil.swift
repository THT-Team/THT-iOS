//
//  ImageUtil.swift
//  FallingTests
//
//  Created by Kanghos on 2023/08/14.
//

import UIKit

// https://designcode.io/swiftui-advanced-handbook-compress-a-uiimage

// TODO: 업로드 용 사이즈에 대한 고민 필요 대부분 프로필 이미지일 듯
extension UIImage {
  func aspectFittedToHeight(_ newHeight: CGFloat = 200) -> UIImage {
    let scale = newHeight / self.size.height
    let newWidth = self.size.width * scale
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)

    return renderer.image { context in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }

  func compressImage() -> UIImage {
    let resized = self.aspectFittedToHeight(200)
    resized.jpegData(compressionQuality: 0.2)

    return resized
  }

  func compressToData() -> Data? {
    self.aspectFittedToHeight(200)
      .jpegData(compressionQuality: 0.2)
  }
  
  func resize(targetSize: CGSize) -> UIImage? {
    let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
    UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.interpolationQuality = .high
    draw(in: newRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

