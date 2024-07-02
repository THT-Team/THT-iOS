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
    let picker = PHPickerControllable(delegate: delegate)
    self.viewControllable.present(picker, animated: true)
  }
}

extension PHPickerViewController: ViewControllable {
  public var uiController: UIViewController { return self }
}


