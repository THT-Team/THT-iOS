//
//  BaseSignUpVC.swift
//  SignUp
//
//  Created by Kanghos on 7/31/24.
//

import UIKit
import DSKit

open class BaseSignUpVC<ViewModel>: TFBaseViewController where ViewModel: ViewModelType {

  public typealias ViewModel = ViewModel
  let viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  open override func navigationSetting() {
//    navigationController?.setNavigationBarHidden(true, animated: false)
    self.navigationItem.hidesBackButton = true
    setBackButton()
  }
}
