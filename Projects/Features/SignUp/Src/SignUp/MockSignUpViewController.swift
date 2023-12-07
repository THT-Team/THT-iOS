//
//  SignUpViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Core

final class MockSignUpViewController: TFBaseViewController {
  var viewModel: MockSignUpViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .magenta
    viewModel.test()
  }
}
