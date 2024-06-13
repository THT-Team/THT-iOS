//
//  SignUpCoordinator+PHPicker.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation
import PhotosUI

import Core

extension SignUpCoordinator {
  public func photoPickerFlow(delegate: PhotoPickerDelegate) {

    // coordinator로 빼기
    var configuration = PHPickerConfiguration(photoLibrary: .shared())

    configuration.filter = PHPickerFilter.images

    configuration.preferredAssetRepresentationMode = .current
    configuration.selection = .ordered

    configuration.selectionLimit = 1

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = delegate
    self.viewControllable.present(picker, animated: true)
  }
}

extension PHPickerViewController: ViewControllable {
  public var uiController: UIViewController { return self }
}

public protocol PhotoPickerDelegate: PHPickerViewControllerDelegate {
  var listener: PhotoPickerListener? { get }
}

public class PhotoPickerDelegator: PhotoPickerDelegate {
  weak public var listener: PhotoPickerListener?

  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss()
    listener?.picker(didFinishPicking: results)
  }

  deinit {
    print("deinit: PhotoPickerDelegate!")
  }
}
