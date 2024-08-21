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

  deinit {
    TFLogger.cycle(name: self)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  public override func bindViewModel() {
    let input = LauncherViewModel.Input(
      viewDidLoad: self.rx.viewDidAppear.asDriver().delay(.seconds(2)).map { _ in }
    )
    let output = viewModel.transform(input: input)

    output.toast
      .emit(with: self, onNext: { owner, message in
        owner.view.makeToast(message)
      })
      .disposed(by: disposeBag)
  }
}
