//
//  MyPageHomeViewController.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import UIKit

import MyPageInterface

import Core
import DSKit

final class MyPageHomeViewController: TFBaseViewController {
  let viewModel: MyPageHomeViewModel
  let mainView = MyPageView()
  private let delegateAction = PublishRelay<MyPageHome.Action>()

  override func loadView() {
    self.view = mainView
  }

  init(viewModel: MyPageHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "마이페이지"
    
    navigationItem.rightBarButtonItem = mainView.rightBarBtn
  }

  override func bindViewModel() {
    self.mainView.delegate = self

    mainView.settingButton.rx.tap
      .debug("tap")
      .map { _ in MyPageHome.Action.settingTap }
      .bind(to: delegateAction)
      .disposed(by: disposeBag)

    _ = mainView.infoCollectionView.rx.itemSelected.map { $0.item }
      .map { MyPageHome.Action.sectionTap($0) }
      .bind(to: delegateAction)

    let input = MyPageHomeViewModel.Input(
      delegateAction: delegateAction.asDriverOnErrorJustEmpty()
      )

    let output = viewModel.transform(input: input)

    output.user
      .drive(mainView.rx.dataSource)
      .disposed(by: disposeBag)

    output.headerModel
      .drive(mainView.rx.headerModel)
      .disposed(by: disposeBag)

    output.toast
      .emit(with: self) { owner, toast in
        owner.view.makeToast(toast)
      }.disposed(by: disposeBag)
    
    output.isDimHidden
      .emit(with: self, onNext: { owner, isHidden in
        UIView.animate(withDuration: 0.3) {
          owner.mainView.blurView.alpha = isHidden ? 0 : 1
        }
      })
      .disposed(by: disposeBag)
  }
}

enum MyPageHome {
  enum Action {
    case photoEdit(Int)
    case photoAdd(Int)
    case nicknameEdit(String)
    case settingTap
    case sectionTap(Int)
  }
}

extension MyPageHomeViewController: MyPageViewDelegate {
  func didTapPhotoEditButton(_ index: Int) {
    delegateAction.accept(.photoEdit(index))
  }
  
  func didTapPhotoAddButton(_ index: Int) {
    delegateAction.accept(.photoAdd(index))
  }
  
  func didTapNicknameEditButton(_ nickname: String) {
    delegateAction.accept(.nicknameEdit(nickname))
  }
}
