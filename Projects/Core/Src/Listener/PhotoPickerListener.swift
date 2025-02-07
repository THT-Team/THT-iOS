//
//  PhotoPickerListener.swift
//  Core
//
//  Created by kangho lee on 7/24/24.
//

import Foundation
import PhotosUI
import UIKit

public struct PhotoItem {
  public let items: PHPickerResult
}

public typealias PhotoPickerHandler = ((PhotoItem) -> Void)

public protocol PhotoPickerListener: AnyObject {
  func picker(didFinishPicking results: [PHPickerResult])
}

public protocol PhotoPickerDelegate: PHPickerViewControllerDelegate {
  var listener: PhotoPickerListener? { get }
}

public class PhotoPickerDelegator: PhotoPickerDelegate {
  weak public var listener: PhotoPickerListener?

  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    listener?.picker(didFinishPicking: results)
  }
  
  public init() { }

  deinit {
    print("deinit: PhotoPickerDelegate!")
  }
}

public class PHPickerControllable: ViewControllable {
  public var uiController: UIViewController { picker }
  public let picker: PHPickerViewController
  public var handelr: PhotoPickerHandler?

  public init(_ handler: PhotoPickerHandler? = nil) {
    self.picker = PHPickerViewController(configuration: Self.defaultConfiguation())
    picker.delegate = self
    self.handelr = handler
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension PHPickerControllable: PHPickerViewControllerDelegate {
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    defer { picker.dismiss(animated: true) }
    if let item = results.first {
      self.handelr?(PhotoItem(items: item))
    }
  }

  static func defaultConfiguation() -> PHPickerConfiguration {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())

    configuration.filter = PHPickerFilter.images

    configuration.preferredAssetRepresentationMode = .current
    configuration.selection = .ordered

    configuration.selectionLimit = 1

    return configuration
  }
}
