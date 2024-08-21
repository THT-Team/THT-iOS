//
//  SignUpCompleteViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import UIKit
import DSKit

final class SignUpCompleteViewController: BaseSignUpVC<SignUpCompleteViewModel> {

  private let mainView = SignUpCompleteView()

  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    mainView.startAnimation()
  }

  override func bindViewModel() {
    self.backButton.isHidden = true
    
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
