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
  @Injected var locationUseCase: LocationUseCaseInterface

  public weak var delegate: MyPageCoordinatorDelegate?
  private lazy var alertBuilder = MyPageAlertBuilder(viewControllable: self.viewControllable)

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

  public func editUserContactsFlow() {
    let vm = UserContactSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = UserContactSettingViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func accountSettingFlow() {
    let vm = AccountSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = AccountSettingViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func settingFlow(_ user: User) {
    let vm = MySettingViewModel(useCase: self.myPageUseCase, locationUseCase: locationUseCase, user: user)
    let vc = MySettingsViewController(viewModel: vm)
    vm.delegate = self

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension MyPageCoordinator: MyPageCoordinatingActionDelegate {
  public func invoke(_ action: MyPageCoordinatingAction) {
    switch action {
    case let .setting(user):
      settingFlow(user)
    case .editUserContacts:
      editUserContactsFlow()
    case .accountSetting:
      accountSettingFlow()

    case let .edit(section):
      sectionFlow(section)

    case let .showLogoutAlert(listener):
      LogOutAlertFlow(listener: listener)
    case let .showDeactivateAlert(listener):
      DeactivateAlertFlow(listener: listener)
    default: break
    }
  }

  private func sectionFlow(_ section: MyPageSection) {
    switch section {
    case .birthday(let string):
      let vc = TFBaseViewController(nibName: nil, bundle: nil)
      self.viewControllable.presentBottomSheet(vc, animated: true)
    default: break
//    case .gender(let gender):
//      <#code#>
//    case .introduction(let string):
//      <#code#>
//    case .preferGender(let gender):
//      <#code#>
//    case .height(let int):
//      <#code#>
//    case .smoking(let frequency):
//      <#code#>
//    case .drinking(let frequency):
//      <#code#>
//    case .religion(let religion):
//      <#code#>
//    case .interest(let array):
//      <#code#>
//    case .idealType(let array):
//      <#code#>
    }
  }

  private func LogOutAlertFlow(listener: LogoutListenr) {
    alertBuilder.buildLogoutAlert(listener: listener)
  }

  private func DeactivateAlertFlow(listener: DeactivateListener) {
    alertBuilder.buildDeactivateAlert(listener: listener)
  }
}
