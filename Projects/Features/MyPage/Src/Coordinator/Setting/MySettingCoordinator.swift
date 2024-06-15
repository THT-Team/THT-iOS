//
//  MySettingCoordinator.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import Foundation

import Core

import Foundation

import MyPageInterface
import SignUpInterface
import Core
import DSKit

public final class MySettingCoordinator: BaseCoordinator {

  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var locationUseCase: LocationUseCaseInterface

  private let myPageAlertBuildable: MyPageAlertBuildable
  private var myPageAlertCoordinator: MyPageAlertCoordinating?

  public weak var delegate: MySettingCoordinatorDelegate?

  private let user: User

  public init(viewControllable: ViewControllable, user: User, myPageAlertBuildable: MyPageAlertBuildable) {
    self.user = user
    self.myPageAlertBuildable = myPageAlertBuildable
    super.init(viewControllable: viewControllable)
  }
}

extension MySettingCoordinator: MySettingCoordinating {
  
  public func settingHomeFlow(_ user: User) {
    let vm = MySettingViewModel(useCase: self.myPageUseCase, locationUseCase: self.locationUseCase, user: user)
    vm.delegate = self
    let vc = MySettingsViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editPhoneNumberFlow() {

  }
  
  public func editEmailFlow() {

  }
  
  public func editUserContactsFlow() {
    let vm = UserContactSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = UserContactSettingViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func alarmSettingFlow() {
    let vm = AlarmSettingViewModel()
    vm.delegate = self
    let vc = AlarmSettingViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func accountSettingFlow() {
    let vm = AccountSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = AccountSettingViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func feedBackFlow() {
    
  }
  
  public func webViewFlow(_ title: String?, _ url: URL) {
    let vc = TFWebViewController(title: title, url: url)
    self.viewControllable.present(vc, animated: true)
  }
}

extension MySettingCoordinator: MySettingCoordinatingActionDelegate {
  public func invoke(_ action: MySettingCoordinatingAction) {
    switch action {
    case .finish:
      delegate?.detachMySetting()
    case .editPhoneNumber:
      editPhoneNumberFlow()
    case .editEmail:
      editEmailFlow()
    case .editUserContacts:
      editUserContactsFlow()
    case .alarmSetting:
      alarmSettingFlow()
    case .feedback:
      feedBackFlow()
    case let .cs(url):
      webViewFlow("자주하는 질문", url)
    case let .locationPolicy(url):
      webViewFlow("위치 정보 이용 약관", url)
    case let .servicePolicy(uRL):
      webViewFlow("서비스 이용 약관", uRL)
    case let .privacyPolicy( uRL):
      webViewFlow("개인정보 처리방침", uRL)
    case .license(let uRL):
      webViewFlow("오픈소스 라이센스", uRL)
    case .businessInfo(let uRL):
      webViewFlow("사업자 정보", uRL)
    case .accountSetting:
      accountSettingFlow()
    case let .showLogoutAlert(listener):
      attachMyPageAlert()
      self.myPageAlertCoordinator?.showLogoutAlert(listener: listener)
    case let .showDeactivateAlert(listener):
      attachMyPageAlert()
      self.myPageAlertCoordinator?.showDeactivateAlert(listener: listener)
    }
  }
}

extension MySettingCoordinator: MyPageAlertCoordinatorDelegate {
  public func detachMyPageAlert() {
    guard let coordinator = self.myPageAlertCoordinator else {
      return
    }
    detachChild(coordinator)
    self.myPageAlertCoordinator = nil
  }

  public func attachMyPageAlert() {
    let coordinator = self.myPageAlertBuildable.build(rootViewControllable: self.viewControllable)
    attachChild(coordinator)
    coordinator.delegate = self
    self.myPageAlertCoordinator = coordinator
  }
}
