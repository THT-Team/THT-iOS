//
//  MySettingCoordinator.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import UIKit

import MyPageInterface
import DSKit
import Domain

public final class MySettingCoordinator: BaseCoordinator {

  public var finishFlow: ((MySettingCoordinatorOption) -> Void)?

  private let factory: MySettingFactoryType

  public init(
    viewControllable: ViewControllable, factory: MySettingFactoryType
  ) {
    self.factory = factory
    super.init(viewControllable: viewControllable)
  }
}

extension MySettingCoordinator: MySettingCoordinating {
  
  public func settingHomeFlow(_ user: User) {
    let (vm, vc) = factory.makeHomeFlow()
    vm.onMenuItem = { [weak self] section, item in
      self?.navigate(section: section, item: item)
    }
    vm.onBackBtn = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
      self?.finishFlow?(.finish)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }

  private func navigate(section: MySetting.Section, item: MySetting.MenuItem) {
    switch section {
    // TODO: email, phoneNumber 분리하기
    case .banner: break
    case .account:
      item.title == "핸드폰 번호"
      ? self.editPhoneNumberRootFlow(phoneNumber: "")
      : self.editEmailRootFlow(email: "")
    case .activity:
      self.editUserContactsFlow()
    case .location:
      break
    case .notification:
      self.alarmSettingFlow()
    case .support, .law:
      guard let url = item.url else {
        self.runFeedbackFlow()
        return
      }
      self.webViewFlow(item.title, url)
    case .accoutSetting:
      self.accountSettingFlow()
    }
  }

  public func editPhoneNumberRootFlow(phoneNumber: String) {
    var (vm, vc) = factory.makePhoneNumberRootFlow(phoneNumber: phoneNumber)
    vm.onUpdate = { [weak self] phoneNumber in
      self?.editPhoneInputFlow(phoneNumber: phoneNumber)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editPhoneInputFlow(phoneNumber: String) {
//      var (vm, vc) = factory
  }
  
  public func editPhoneAuthFlow(phoneNumber: String) {
    fatalError()
  }
  
  public func editEmailRootFlow(email: String) {
    var (vm, vc) = factory.makeEmailRootView(email: email)
    vm.onUpdate = { [weak self] email in
      self?.editEmailFlow(email: email)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editEmailFlow(email: String) {
    var (vm, vc) = factory.makeEmailView(email: email)
    vm.onComplete = { [weak self] email in
      self?.viewControllable.popViewController(animated: true)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editUserContactsFlow() {
    let (vm, vc) = factory.makeEditUserContacts()
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func alarmSettingFlow() {
    let (vm, vc) = factory.makeAlarmSetting()

    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func accountSettingFlow() {
    let (vm, vc) = factory.makeAccountSetting()
    vm.onRoot = { [weak self] in
      DispatchQueue.main.async {
        self?.finishFlow?(.toRoot)
      }
    }

    vm.onWithDrawal = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
      self?.withdrawalFlow()
    }

    vm.showDeactivateAlert = { [weak self] handler in
      self?.runAlert(handler, type: .deactivate)
    }

    vm.showLogOutAlert = { [weak self] handler in
      self?.runAlert(handler, type: .logout)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func runAlert(_ handler: AlertHandler, type: MyPageAlertType) {
    let coordinator = factory.buildMyPageCoordinator(rootViewControllable: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.showAlert(handler, alertType: type)
  }

  public func runFeedbackFlow() {
    var coordinator = factory.buildInquiryCoordinator(rootViewControllable: self.viewControllable)
    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.start()
  }
  
  public func webViewFlow(_ title: String?, _ url: URL) {
    let vc = TFWebViewController(title: title, url: url)
    self.viewControllable.present(vc, animated: true)
  }

  public func withdrawalFlow() {
    var (vm, vc) = factory.makeWithdrawal()
    vm.onSelect = { [weak self] reason in
      self?.withdrawalDetailFlow(reason)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func withdrawalDetailFlow(_ reason: WithdrawalReason) {
    var (vm, vc) = factory.makeWithdrawalDetail(reason)
    vm.onWithdrawComplete = { [weak self] in
      self?.compleflow()
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }

  func compleflow() {
    var vc = factory.makeWithdrawComplete()
    
    self.viewControllable.present(vc, animated: true)
  }
}
