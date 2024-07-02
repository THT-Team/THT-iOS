//
//  InquiryViewController.swift
//  MyPage
//
//  Created by Kanghos on 7/20/24.
//

import UIKit
import DSKit

public final class InquiryViewController: TFBaseViewController {
  public typealias ViewModel = InquiryViewModel
  private let mainView = InquiryView()

  private let viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  public override func loadView() {
    self.view = mainView
  }

  public override var backButton: UIButton {
    mainView.headerView.backButton
  }

  public override func navigationSetting() {
//    super.navigationSetting()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  public override func bindViewModel() {
    view.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] tap in
        guard let self else { return }
        tap.cancelsTouchesInView = false
        let location = tap.location(in: self.view)
        let touchedView = view.hitTest(location, with: nil)
        if !(touchedView is TFBaseTextView || touchedView is TFBaseField) {
          view.endEditing(true)
        }
      })
      .disposed(by: disposeBag)

    let backTrigger = Signal.merge(mainView.cardView.backBtn.rx.tap.asSignal(), backButton.rx.tap.asSignal())

    let input = ViewModel.Input(
      email: mainView.emailField.rx.text.orEmpty.asDriver(),
      content: mainView.textView.rx.text.orEmpty.asDriver(),
      btnTap: mainView.nextBtn.rx.tap.asSignal(), 
      policyTap: mainView.policyBtn.rx.isSelected.asSignal().map { _ in },
      cardBtnTap: backTrigger)

    let output = viewModel.transform(input: input)

    output.isBtnEnabled
      .drive(mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
    output.showCard
      .map { false }
      .emit(to: mainView.cardView.rx.isHidden)
      .disposed(by: disposeBag)
    output.showCard
      .do(onNext: { [weak self] _ in 
        self?.mainView.showDimView()
        guard let self else { return }
        DispatchQueue.main.async {
          self.mainView.bringSubviewToFront(self.mainView.cardView)
        }
      })
      .emit(with: self) { owner, _ in
        owner.mainView.cardView.transform = CGAffineTransform(translationX: 0, y: 10).scaledBy(x: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
          owner.mainView.cardView.isHidden = false
          owner.mainView.cardView.transform = .identity
        }
      }.disposed(by: disposeBag)

    output.emailValidateMessage
      .emit(with: self) { owner, message in
        owner.mainView.emailField.send(action: .error(message: message))
      }.disposed(by: disposeBag)

    output.toast
      .map(\.localizedDescription)
      .drive(with: self) { owner, message in
        owner.mainView.makeToast(message)
      }.disposed(by: disposeBag)
  }
}
