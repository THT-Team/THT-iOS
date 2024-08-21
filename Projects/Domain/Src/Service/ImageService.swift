//
//  ImageService.swift
//  Domain
//
//  Created by Kanghos on 7/30/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol ImageServiceType: PHPickerHandler {
  func uploadImages(imageDataArray: [Data], bucket: Bucket) -> Single<[String]>
  func uploadImage(imageData: Data, bucket: Bucket) -> Single<String>
}

public enum ImageError: Error {
  case invalidData
  case firebaseError(String)
}

public enum Bucket {
  case profile
  case chat(id: String)

  public var key: String {
    switch self {
    case .profile: return "profile"
    case .chat(let id): return "chat/\(id)"
    }
  }
}
