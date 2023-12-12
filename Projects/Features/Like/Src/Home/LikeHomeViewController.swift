//
//  LikeViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit
import Core

public final class LikeHomeViewController: TFBaseViewController {

  var viewModel: LikeHomeViewModel!
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.test()
  }
}
