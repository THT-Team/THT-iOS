//
//  TFLauncherViewController.swift
//  AuthDemo
//
//  Created by Kanghos on 6/4/24.
//

import DSKit
import Foundation

public final class TFAuthLauncherViewController: TFLaunchViewController {
  private let viewModel: LauncherViewModel

  public init(viewModel: LauncherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }


  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  public override func bindViewModel() {
    let input = LauncherViewModel.Input(
      viewDidLoad: self.rx.viewDidAppear.asDriver().delay(.seconds(1)).map { _ in }
    )
    let output = viewModel.transform(input: input)

    output.state
      .drive()
      .disposed(by: disposeBag)
  }
}
