//
//  MyPageCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface
import Core
import DSKit

public final class MyPageCoordinator: BaseCoordinator {

  @Injected var myPageUseCase: MyPageUseCaseInterface

  private let mySettingBuildable: MySettingBuildable
  private var mySettingCoordinator: MySettingCoordinating?

  public weak var delegate: MyPageCoordinatorDelegate?

  init(viewControllable: ViewControllable, mySettingBuildable: MySettingBuildable) {
    self.mySettingBuildable = mySettingBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }
}

extension MyPageCoordinator: MyPageCoordinating {

  public func homeFlow() {
    let viewModel = MyPageHomeViewModel(myPageUseCase: myPageUseCase)
    viewModel.delegate = self

    let viewController = MyPageHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func editNicknameFlow(nickname: String) {

  }

  public func editphotoFlow() {

  }

  public func editPreferGenderBottomSheetFlow(prefetGender: SignUpInterface.Gender) {
    
  }

  public func editHeightBottomSheetFlow(height: Int) {

  }
}

// MARK: Navigate Action

extension MyPageCoordinator: MyPageCoordinatingActionDelegate {
  public func invoke(_ action: MyPageCoordinatingAction) {
    switch action {
    case let .setting(user):
      attachMySetting(user)

    // Cell 누르면 Section casting해서 넘겨줌
    case let .edit(section):
      sectionFlow(section)

    default: break
    }
  }

  private func sectionFlow(_ section: MyPageSection) {
    switch section {
    case .birthday(let string):
      let vc = TFBaseViewController(nibName: nil, bundle: nil)
      self.viewControllable.presentBottomSheet(vc, animated: true)
    default: break
    }
  }
}

// MARK: MySetting

extension MyPageCoordinator: MySettingCoordinatorDelegate {
  public func detachMySetting() {
    guard let coordinator = self.mySettingCoordinator else {
      return
    }

    self.viewControllable.popViewController(animated: true)
    self.detachChild(coordinator)
    self.mySettingCoordinator = nil
  }

  public func attachMySetting(_ user: User) {
    let coordinator = self.mySettingBuildable.build(rootViewControllable: self.viewControllable, user: user)
    coordinator.delegate = self
    self.attachChild(coordinator)
    self.mySettingCoordinator = coordinator
    coordinator.settingHomeFlow(user)
  }
}
