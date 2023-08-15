//
//  MyPageViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

final class MyPageViewController: TFBaseViewController {
  
  private let viewModel: MyPageViewModel
  
  init(viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
