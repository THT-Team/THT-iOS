//
//  PHAssetHandler.swift
//  Domain
//
//  Created by Kanghos on 7/30/24.
//

import UIKit
import RxSwift
import PhotosUI

public enum AssetError: Error {
  case invalidAsset
  case cannotLoad
}

public protocol PHPickerHandler {
  func bind(_ asset: PHPickerResult, imageSize: ImageSize) -> Single<Data>
}
//
//public final class PhotoService: PHPickerHandler {
//  public init() { }
//  public func bind(_ asset: PHPickerResult) -> Single<Data> {
//    return .create { observer in
//      let itemProvider = asset.itemProvider
//      if itemProvider.canLoadObject(ofClass: UIImage.self) {
//        itemProvider.loadObject(ofClass: UIImage.self) { item, error in
//          if let image = item as? UIImage,
//             let imageData = image.jpegData(compressionQuality: 1.0)
//          {
//            observer(.success(imageData))
//          } else {
//            observer(.failure(error ?? AssetError.invalidAsset))
//          }
//        }
//      } else {
//        observer(.failure(AssetError.invalidAsset))
//      }
//      return Disposables.create { }
//    }
//  }
//}
