//
//  SignUpCompleteViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import UIKit
import DSKit

final class SignUpCompleteViewController: TFBaseViewController {
  typealias ViewModel = SignUpCompleteViewModel

  private let mainView = SignUpCompleteView()
  private let viewModel: ViewModel

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    mainView.startAnimation()
  }

  override func bindViewModel() {
    let input = ViewModel.Input(
      nextBtnTap: mainView.nextBtn.rx.tap.asDriver()
    )

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

    output.profileImage
      .compactMap { $0 }
      .drive(with: self, onNext: { owner, data in
        owner.mainView.imageView.image = UIImage(data: data)
      })
      .disposed(by: disposeBag)
  }
}
