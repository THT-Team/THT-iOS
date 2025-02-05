//
//  LIkeProfileViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//


import UIKit

import DSKit

import LikeInterface
import Domain
import RxSwift
import RxCocoa

final class LikeProfileViewController: TFBaseViewController {
  private lazy var mainView = TFProfileView()
  private let subButtonView = LikeButtonView()
  public private(set) lazy var visualEffectView: UIVisualEffectView = {
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    visualView.isHidden = true
    return visualView
  }()
  private let reportRelay = PublishRelay<Void>()

  private let viewModel: LikeProfileViewModel

  init(viewModel: LikeProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    self.view = mainView
  }

  override func makeUI() {
    self.view.addSubviews(subButtonView, visualEffectView)

    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    subButtonView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.centerY.equalTo(mainView.profileCollectionView.snp.bottom)
    }
  }

  override func bindViewModel() {
    mainView.reportTap = { [weak self] in
      self?.reportRelay.accept(())
    }

    let input = LikeProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asSignal().map { _ in },
      rejectTrigger: subButtonView.nextTimeButton.rx.tap.asSignal(),
      likeTrigger: subButtonView.chatButton.rx.tap.asSignal(),
      closeTrigger: mainView.topicBarView.closeButton.rx.tap.asSignal(),
      reportTrigger: reportRelay.asSignal()
    )
    let output = viewModel.transform(input: input)

    output.topic.drive(mainView.rx.topicBar)
    .disposed(by: disposeBag)

    output.sections
      .drive(mainView.rx.sections)
      .disposed(by: disposeBag)

    output.isBlurHidden
      .drive(visualEffectView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
