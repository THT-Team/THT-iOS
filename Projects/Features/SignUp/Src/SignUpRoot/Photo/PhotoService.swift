//
//  PhotoService.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit
import PhotosUI

import RxSwift

enum AssetError: Error {
  case invalidAsset
  case cannotLoad
}

protocol PHPickerHandler {
  func bind(_ asset: PHPickerResult) -> Single<Data>
}

final class PhotoService: PHPickerHandler {
  func bind(_ asset: PHPickerResult) -> Single<Data> {
    return .create { observer in
      let itemProvider = asset.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { item, error in
          if let image = item as? UIImage,
             let imageData = image.jpegData(compressionQuality: 1.0)
          {
            observer(.success(imageData))
          } else {
            observer(.failure(error ?? AssetError.invalidAsset))
          }
        }
      } else {
        observer(.failure(AssetError.invalidAsset))
      }
      return Disposables.create { }
    }
  }
}
