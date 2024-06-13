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
      viewDidload: rx.viewDidAppear.asDriver().map { _ in },
      delegateAction: delegateAction.asDriverOnErrorJustEmpty()
      )

    let output = viewModel.transform(input: input)

    output.user
      .drive(with: self, onNext: { owner, datasource in
        owner.mainView.bind(dataSource: datasource)
      })
      .disposed(by: disposeBag)

    output.photos
      .drive(with: self) { owner, photos in
        owner.mainView.photos = photos
      }
      .disposed(by: disposeBag)
  }
}

enum MyPageHome {
  enum Action {
    case photoEdit(Int)
    case photoAdd(Int)
    case nicknameEdit
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
  
  func didTapNicknameEditButton() {
    delegateAction.accept(.nicknameEdit)
  }
}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct MyPageViewController_Preview: PreviewProvider {
//  static var previews: some View {
//    let vm = MyPageHomeViewModel(myPageUseCase: MyPageUseCase(repository: MockMyPageRepository()))
//    let vc = MyPageHomeViewController(viewModel: vm)
//    return vc.showPreview()
//  }
//}
//#endif
