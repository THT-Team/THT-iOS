//
//  PhoneCertificationViewController.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import DSKit

final class NicknameInputViewController: TFBaseViewController {

  fileprivate let mainView = NicknameView()

  private let viewModel: NicknameInputViewModel

  init(viewModel: NicknameInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    mainView.nicknameInputField.textField.becomeFirstResponder()
  }

  override func makeUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func bindViewModel() {
    let viewWillAppear =  rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .do(onNext: { [weak self] _ in
        self?.mainView.nicknameInputField.textField.becomeFirstResponder()
      })
      .map { _ in }
      .asDriver(onErrorDriveWith: .empty())

    let input = NicknameInputViewModel.Input(
      viewWillAppear: viewWillAppear,
      nickname: mainView.nicknameInputField.textField.rx.text.orEmpty.asDriver(),
      nextBtn: mainView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)
    
    output.errorField
      .debug("errorField")
      .drive(with: self, onNext: { owner, message in
        owner.mainView.nicknameInputField.render(state: .error(error: .validate(text: message)))
      })
      .disposed(by: disposeBag)
    
    output.validate
      .drive(mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.initialValue
      .debug("initial")
      .drive(mainView.nicknameInputField.rx.text)
      .disposed(by: disposeBag)
  }
}
