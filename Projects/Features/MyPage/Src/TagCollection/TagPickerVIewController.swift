//
//  TagPickerVIewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/11/24.
//

import UIKit

import DSKit
import Core

final class TagsPickerViewController: TFBaseViewController {
  let mainView = TagsPickerView()

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

  }

  override func updateViewConstraints() {
    super.updateViewConstraints()

  }


}
