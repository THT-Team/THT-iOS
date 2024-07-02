//
//  ImageService.swift
//  Data
//
//  Created by Kanghos on 7/30/24.
//

import UIKit

import RxSwift
import FirebaseStorage
import Domain
import PhotosUI

public class ImageService: ImageServiceType {
  public init() { }
  public func uploadImages(imageDataArray: [Data], bucket: Bucket) -> Single<[String]> {
    return Observable.from(imageDataArray)
      .flatMap { [weak self] data -> Single<String> in
        guard let self else { return .error(ImageError.invalidData) }
        return self.uploadImage(imageData: data, bucket: bucket)
      }.toArray()
      .debug("firebase Storage Image Upload URL")
  }
  public func uploadImage(imageData: Data, bucket: Bucket) -> Single<String> {
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"

    let imageName = ImageNameStrategy.generateTimestampName()
    let firebaseRef = Storage.storage().reference().child("\(bucket.key)/\(imageName)")

    return .create { observer in
      let task = firebaseRef.putData(imageData, metadata: metaData) { metaData, error in
        if let error {
          observer(.failure(ImageError.firebaseError(error.localizedDescription)))
          return
        } else {
          firebaseRef.downloadURL { result in
            switch result {
            case .success(let url):
              observer(.success(url.absoluteString))
              return
            case .failure(let error):
              observer(.failure(ImageError.firebaseError(error.localizedDescription)))
              return
            }
          }
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
  }

  public func bind(_ asset: PHPickerResult, imageSize: ImageSize) -> Single<Data> {
    return .create { observer in
      let itemProvider = asset.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { item, error in
          if let image = item as? UIImage,
             let imageData = try? ImageCompressor.imageComporessorToData(image: image, size: imageSize)
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

struct ImageNameStrategy {
  static func generateTimestampName() -> String {
    return String(Date().timeIntervalSince1970)
  }
}
