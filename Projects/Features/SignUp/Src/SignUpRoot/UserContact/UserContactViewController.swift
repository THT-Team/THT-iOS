//
//  UserContactViewController.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/2/24.
//

import UIKit
import DSKit

final class UserContactViewController: TFBaseViewController {
  typealias ViewModel = UserContactViewModel
  typealias Action = ViewModel.Action
  
  private let mainView = UserContactView()
  private let viewModel: UserContactViewModel
  
  init(viewModel: UserContactViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = mainView
  }
  
  override func bindViewModel() {
    let block = mainView.blockBtn.rx.tap
      .asDriver()
      .map { Action.block }

    let skip = mainView.layterBtn.rx.tap
      .asDriver()
      .map { Action.skip }
    let actiontrigger = Driver.merge(block, skip)
    let input = UserContactViewModel.Input(actionTrigger: actiontrigger)
    let output = viewModel.transform(input: input)
    
    output.toast
      .emit(with: self) { owner, message in
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)

        owner.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          owner.dismiss(animated: true)
        }
      }
      .disposed(by: disposeBag)
  }
}
