//
//  MySettingCoordinator.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/15/24.
//

import UIKit

import MyPageInterface
import SignUpInterface
import AuthInterface
import DSKit

public protocol MySettingCoordinatorDependency {
  var myPageAlertBuildable: MyPageAlertBuildable { get }
  var inquiryBuildable: InquiryBuildable { get }
  var authViewFactory: AuthViewFactoryType { get }
}

public final class MySettingCoordinator: BaseCoordinator {

  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var locationUseCase: LocationUseCaseInterface
  @Injected var authUseCase: AuthUseCaseInterface

  private let myPageAlertBuildable: MyPageAlertBuildable
  private var myPageAlertCoordinator: MyPageAlertCoordinating?

  private let inquiryBuildable: InquiryBuildable
  private var inquiryCoordinator: InquiryCoordinating?
  private let authViewFactory: AuthViewFactoryType

  public weak var delegate: MySettingCoordinatorDelegate?

  public var finishFlow: ((MySettingCoordinatorOption) -> Void)?

  private let user: User

  public init(
    viewControllable: ViewControllable, user: User,
    dependency: MySettingCoordinatorDependency
  ) {
    self.user = user
    self.myPageAlertBuildable = dependency.myPageAlertBuildable
    self.inquiryBuildable = dependency.inquiryBuildable
    self.authViewFactory = dependency.authViewFactory
    super.init(viewControllable: viewControllable)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension MySettingCoordinator: MySettingCoordinating {
  public func editPhoneNumberFlow() {
    
  }
  
  public func editEmailFlow() {
    
  }
  
  
  public func settingHomeFlow(_ user: User) {
    let vm = MySettingViewModel(useCase: self.myPageUseCase, locationUseCase: self.locationUseCase, user: user)
    vm.delegate = self
    let vc = MySettingsViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editPhoneNumberRootFlow(phoneNumber: String) {
    let vm = PhoneNumberEditRootVM(phoneNumber: phoneNumber)
    vm.delegate = self
    let vc = PhoneNumberEditRootVC(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editPhoneInputFlow(phoneNumber: String) {
    self.viewControllable.pushViewController(authViewFactory.makePhoneNumberScene(delegate: self), animated: true)
  }
  
  public func editPhoneAuthFlow(phoneNumber: String) {
    let vm = PhoneNumberAuthVM(phoneNumber: phoneNumber, useCase: myPageUseCase, authUseCase: authUseCase)
    vm.delegate = self
    let vc = authViewFactory.makePhoneAuthScene(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editEmailRootFlow(email: String) {
    let vm = EmailEditRootVM(email: email)
    vm.delegate = self
    let vc = EmailEditRootVC(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editEmailFlow(email: String) {
    let vm = EmailEdittVM(email: email, useCase: myPageUseCase)
    vm.delegate = self
    let vc = EmailEditVC(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func editUserContactsFlow() {
    let vm = UserContactSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = UserContactSettingViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func alarmSettingFlow() {
    let vm = AlarmSettingViewModel(myPageUseCase: self.myPageUseCase)
    vm.delegate = self
    let vc = AlarmSettingViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  public func accountSettingFlow() {
    let vm = AccountSettingViewModel(useCase: self.myPageUseCase)
    vm.onRoot = { [weak self] in
      self?.finishFlow?(.toRoot)
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

    let vc = AccountSettingViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func runAlert(_ handler: AlertHandler, type: MyPageAlertType) {
    let coordinator = self.myPageAlertBuildable.build(rootViewControllable: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.showAlert(handler, alertType: type)
  }

  public func feedBackFlow() {
    attachInquiry()
  }
  
  public func webViewFlow(_ title: String?, _ url: URL) {
    let vc = TFWebViewController(title: title, url: url)
    self.viewControllable.present(vc, animated: true)
  }

  public func withdrawalFlow() {
    let vm = SelectWithdrawalViewModel()
    vm.delegate = self
    let vc = SelectWithdrawViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func withdrawalDetailFlow(_ reason: WithdrawalReason) {
    let vm = WithdrawalDetailViewModel(withdrawalDetail: WithdrawalReasonDetailProvider.createReasonDetail(reason), useCase: myPageUseCase)
    vm.delegate = self
    let vc = WithdrawalDetailViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  func compleflow() {
    let vc = WithdrawalCompleteViewController()
    vc.delegate = self
    vc.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(vc, animated: true)
  }
}

extension MySettingCoordinator: MySettingCoordinatingActionDelegate {
  public func invoke(_ action: MySettingCoordinatingAction) {
    switch action {
    case .toRoot, .logout:
      viewControllable.popViewController(animated: true)
      viewControllable.popViewController(animated: true)
      finishFlow?(.finish)
    case .finish:
      if (self.viewControllable.uiController as? UINavigationController)?.topViewController is MySettingsViewController {
        viewControllable.popViewController(animated: true)
        finishFlow?(.finish)
      }
    case let .editPhoneNumber(phoneNumber):
      editPhoneNumberRootFlow(phoneNumber: phoneNumber)
    case let .editEmail(email):
      editEmailRootFlow(email: email)
    case .editUserContacts:
      editUserContactsFlow()
    case .alarmSetting:
      alarmSettingFlow()
    case .feedback:
      feedBackFlow()
    case let .webView(webviewInfo):
      webViewFlow(webviewInfo.title, webviewInfo.url)
    case .accountSetting:
      accountSettingFlow()
    case .selectWithdrawal:
      self.viewControllable.popViewController(animated: true)
      withdrawalFlow()
    case let .WithdrawalDetail(reason):
      withdrawalDetailFlow(reason)
    case .withdrawalComplete:
      compleflow()
    }
  }
}

extension MySettingCoordinator: InquiryCoordinatingDelegate {
  public func detachInquiry(_ coordinator: Core.Coordinator) {
    guard let inquiryCoordinator else { return }
    self.detachChild(inquiryCoordinator)
    self.inquiryCoordinator = nil
  }
  
  public func attachInquiry() {
    if self.inquiryCoordinator != nil { return }
    let coordinator = self.inquiryBuildable.build(rootViewControllable: self.viewControllable)
    coordinator.delegate = self
    self.attachChild(coordinator)
    self.inquiryCoordinator = coordinator

    coordinator.start()
  }
}

extension MySettingCoordinator: PhoneAuthViewDelegate, PhoneNumberEditRootViewDelegate, PhoneInputVCDelegate {
  public func didTapPhoneInputBtn(_ phoneNumber: String) {
    editPhoneAuthFlow(phoneNumber: phoneNumber)
  }
  
  public func didTapOnRootUpdatePhoneNum(_ phoneNumber: String) {
    editPhoneInputFlow(phoneNumber: phoneNumber)
  }
  
  public func didAuthComplete(option: AuthInterface.PhoneAuthOption) {
    if case .none = option {
      DispatchQueue.main.async {
        self.viewControllable.popViewController(animated: false)
        self.viewControllable.popViewController(animated: true)
      }
    }
  }
}

extension MySettingCoordinator: EmailEditRootViewDelegate, EmailEditDelegate {
  public func didTapOnRootUpdateEmail(_ email: String) {
    editEmailFlow(email: email)
  }

  public func didEmailTap(_ email: String) {
    DispatchQueue.main.async {
      self.viewControllable.popViewController(animated: true)
    }
  }
}
