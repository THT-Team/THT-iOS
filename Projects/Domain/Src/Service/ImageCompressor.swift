//
//  ImageCompressor.swift
//  Domain
//
//  Created by Kanghos on 7/30/24.
//

import UIKit

public enum ImageSize {
  case profile
  case chatRoom

  var size: CGSize {
    switch self {
    case .profile: return CGSize(width: 600, height: 600)
    case .chatRoom: return CGSize(width: 500, height: 500)
    }
  }
}

public struct ImageCompressor {
  public static func imageComporessor(image: UIImage, size: ImageSize) throws -> UIImage {
    guard let data = try? imageComporessorToData(image: image, size: size),
          let compressedImage = UIImage(data: data) 
    else {
      throw ImageError.invalidData
    }
    return compressedImage
  }

  public static func imageComporessorToData(image: UIImage, size: ImageSize) throws -> Data {
    guard
      let resized = resizeImage(image: image, targetSize: size.size),
      let data = resized.jpegData(compressionQuality: 0.7) else {
      throw ImageError.invalidData
    }
    return data
  }

  private static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height

    var newSize: CGSize
    if widthRatio > heightRatio {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
