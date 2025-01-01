//
//  MySettingFactory.swift
//  MyPage
//
//  Created by Kanghos on 12/23/24.
//

import UIKit

import MyPageInterface
import SignUpInterface
import AuthInterface
import DSKit

public protocol MySettingFactoryType {
  var userStore: UserStore { get }
  func makeHomeFlow() -> (MySettingViewModel, ViewControllable)
  func makePhoneNumberRootFlow(phoneNumber: String) -> (PhoneNumberEditRootVM, ViewControllable)
  
  func makeEmailView(email: String) -> (EmailEdittVM, ViewControllable)
  func makeEmailRootView(email: String) -> (EmailEditRootVM, ViewControllable)
  func makeEditUserContacts() -> (UserContactSettingViewModel, ViewControllable)
  func makeAccountSetting() -> (AccountSettingViewModel, ViewControllable)
  func makeAlarmSetting() -> (AlarmSettingViewModel, ViewControllable)
  func makeWithdrawal() -> (SelectWithdrawalViewModel, ViewControllable)
  func makeWithdrawalDetail(_ reason: WithdrawalReason) -> (WithdrawalDetailViewModel, ViewControllable)
  func makeWithdrawComplete() -> ViewControllable

  func buildInquiryCoordinator(rootViewControllable: any ViewControllable) -> InquiryCoordinating
  func buildMyPageCoordinator(rootViewControllable: ViewControllable) -> MyPageAlertCoordinating
}

extension MyPageFactory: MySettingFactoryType {

  public func makeHomeFlow() -> (MySettingViewModel, ViewControllable) {
    let vm = MySettingViewModel(useCase: self.myPageUseCase, locationUseCase: self.locationUseCase, userStore: self.userStore)
    let vc = MySettingsViewController(viewModel: vm)
    return (vm, vc)
  }

  // TODO: 기존 꺼 재활용하기 이거 말고 Auth 꺼
  // TODO: 번호를 변경하고 다시 또 변경한다면, factory가 가지고 있는 유저의 번호가 다르다.
  public func makePhoneNumberRootFlow(phoneNumber: String) -> (PhoneNumberEditRootVM, ViewControllable) {
    let vm = PhoneNumberEditRootVM(phoneNumber: phoneNumber)
    let vc = PhoneNumberEditRootVC(viewModel: vm)
    return (vm, vc)
  }

  public func makeEmailRootView(email: String) -> (EmailEditRootVM, ViewControllable) {
    let vm = EmailEditRootVM(email: email)
    let vc = EmailEditRootVC(viewModel: vm)

    return (vm, vc)
  }

  public func makeEmailView(email: String) -> (EmailEdittVM, ViewControllable) {
    let vm = EmailEdittVM(email: email, useCase: myPageUseCase)
    let vc = EmailEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func makeEditUserContacts() -> (UserContactSettingViewModel, ViewControllable) {
    let vm = UserContactSettingViewModel(useCase: self.myPageUseCase)
    let vc = UserContactSettingViewController(viewModel: vm)

    return (vm, vc)
  }

  public func makeAccountSetting() -> (AccountSettingViewModel, ViewControllable) {
    let vm = AccountSettingViewModel(useCase: self.myPageUseCase)
    let vc = AccountSettingViewController(viewModel: vm)

    return (vm, vc)
  }

  public func makeAlarmSetting() -> (AlarmSettingViewModel, ViewControllable) {
    let vm = AlarmSettingViewModel(myPageUseCase: myPageUseCase)
    let vc = AlarmSettingViewController(viewModel: vm)

    return (vm, vc)
  }

  public func makeWithdrawal() -> (SelectWithdrawalViewModel, ViewControllable) {
    let vm = SelectWithdrawalViewModel()
    let vc = SelectWithdrawViewController(viewModel: vm)
    return (vm, vc)
  }

  public func makeWithdrawalDetail(_ reason: WithdrawalReason) -> (WithdrawalDetailViewModel, ViewControllable) {
    let vm = WithdrawalDetailViewModel(withdrawalDetail: WithdrawalReasonDetailProvider.createReasonDetail(reason), useCase: myPageUseCase)
    let vc = WithdrawalDetailViewController(viewModel: vm)
    return (vm, vc)
  }
  public func makeWithdrawComplete() -> any Core.ViewControllable {
    let vc = WithdrawalCompleteViewController()
    vc.modalPresentationStyle = .overFullScreen
    return vc
  }
}

extension MyPageFactory {
  public func buildMyPageCoordinator(rootViewControllable: ViewControllable) -> MyPageAlertCoordinating {

    let coordinator = MyPageAlertCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }

  public func buildInquiryCoordinator(rootViewControllable: any ViewControllable) -> InquiryCoordinating {
    inquiryBuilder.build(rootViewControllable: rootViewControllable)
  }
}
