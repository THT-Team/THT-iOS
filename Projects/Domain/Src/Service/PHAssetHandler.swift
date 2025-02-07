//
//  PHAssetHandler.swift
//  Domain
//
//  Created by Kanghos on 7/30/24.
//

import UIKit
import RxSwift
import Core

public enum AssetError: Error {
  case invalidAsset
  case cannotLoad
}

public protocol PHPickerHandler {
  func bind(_ asset: PhotoItem, imageSize: ImageSize) -> Single<Data>
}
