//
//  PhotoPickerListener.swift
//  Core
//
//  Created by kangho lee on 7/24/24.
//

import Foundation
import PhotosUI
import UIKit

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
  
  public init(delegate: PhotoPickerDelegate) {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    
    configuration.filter = PHPickerFilter.images

    configuration.preferredAssetRepresentationMode = .current
    configuration.selection = .ordered

    configuration.selectionLimit = 1
    
    self.picker = PHPickerViewController(configuration: configuration)
    picker.delegate = delegate
  }
}
