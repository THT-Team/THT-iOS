//
//  AuthCoordinator.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core
import AuthInterface
import SignUpInterface

protocol AuthCoordinatingActionDelegate: AnyObject {
//  func invoke(_ action: AuthCoordinatingAction)
  func invoke(_ action: AuthNavigation)
}

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {

  @Injected private var authUseCase: AuthUseCaseInterface

  private let signUpBuildable: SignUpBuildable
  private let authViewFactory: AuthViewFactoryType
  private var signUpCoordinator: SignUpCoordinating?

  private let inquiryBuildable: InquiryBuildable
  private var inquiryCoordinator: InquiryCoordinating?

  public weak var delegate: AuthCoordinatingDelegate?

  public init(
    signUpBuildable: SignUpBuildable,
    inquiryBuildable: InquiryBuildable,
    authViewFactory: AuthViewFactoryType,
    viewControllable: ViewControllable
  ) {
    self.signUpBuildable = signUpBuildable
    self.inquiryBuildable = inquiryBuildable
    self.authViewFactory = authViewFactory
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    replaceWindowRootViewController(rootViewController: self.viewControllable)

    rootFlow()
  }


  // MARK: Launch Screen
  public func launchFlow() {

  }

  // MARK: 인증 토큰 재발급 또는 가입 시
  public func rootFlow() {
    let viewModel = AuthRootViewModel(useCase: authUseCase)
    viewModel.delegate = self

    let viewController = AuthRootViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }

  public func phoneNumberFlow() {
    let vc = authViewFactory.makePhoneNumberScene(delegate: self)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func phoneAuthFlow(phoneNumber: String) {
    let vc = authViewFactory.makePhoneAuthScene(viewModel: PhoneAuthVM(phoneNumber: phoneNumber, delegate: self, useCase: authUseCase))
    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension AuthCoordinator: AuthCoordinatingActionDelegate {

  func invoke(_ action: AuthNavigation) {
    switch action {
    case .phoneNumber(let snsUserInfo):
      phoneNumberFlow()
    case .policy(let snsUserInfo):
      attachSignUp(.startPolicy(snsUserInfo))
    case .main:
      self.delegate?.detachAuth(self)
    case .inquiry:
      attachInquiryCoordinator()
    }
  }

  public func snsFlow(type: AuthType) {
    switch type {
    case .phoneNumber:
      phoneNumberFlow()
    case .sns(let userInfo):
      switch type.snsType {
      case .kakao, .naver:
        attachSignUp(.startPolicy(userInfo))
      case .google:
        phoneNumberFlow()
        break
      case .apple:
        phoneNumberFlow()
        break
      case .normal:
        break
      }
    }
  }
}

// MARK: InquiryCoordinator

extension AuthCoordinator: InquiryCoordinatingDelegate {
  public func attachInquiry() {
    attachInquiryCoordinator()
  }

  public func detachInquiry(_ coordinator: Core.Coordinator) {
    detachInquiryCoordinator()

  }
  func attachInquiryCoordinator() {
    if self.inquiryCoordinator != nil { return }
    let coordinator = self.inquiryBuildable.build(rootViewControllable: self.viewControllable)
    coordinator.delegate = self
    self.attachChild(coordinator)
    self.inquiryCoordinator = coordinator

    coordinator.start()
  }

  func detachInquiryCoordinator() {
    guard let inquiryCoordinator else { return }
    self.detachChild(inquiryCoordinator)
    self.inquiryCoordinator = nil
  }
}

// MARK: SignUpCoordinator

extension AuthCoordinator: SignUpCoordinatorDelegate {
  public func detachSignUp(_ coordinator: Coordinator, _ option: FinishSignUpOption) {
    self.detachSignUpCoordinator()
    switch option {
    case .back: break
    case .complete:
      self.delegate?.detachAuth(self)
    }
  }

  public func attachSignUp(_ option: SignUpOption) {
    if self.signUpCoordinator != nil { return }
    let coordinator = self.signUpBuildable.build(rootViewControllable: self.viewControllable)
    coordinator.delegate = self
    self.attachChild(coordinator)
    self.signUpCoordinator = coordinator
    coordinator.start(option)
  }

  func detachSignUpCoordinator() {
    guard let coordinator = self.signUpCoordinator else { return }
    self.detachChild(coordinator)
    self.signUpCoordinator = nil
  }
}

extension AuthCoordinator: PhoneInputVCDelegate, PhoneAuthViewDelegate {
  public func didTapPhoneInputBtn(_ phoneNumber: String) {
    phoneAuthFlow(phoneNumber: phoneNumber)
  }

  public func didAuthComplete(option: PhoneAuthOption) {
    viewControllable.dismiss()
    switch option {
    case .signUp(let phoneNumber):
      attachSignUp(.start(phoneNumber: phoneNumber))
    case .signIn:
      self.delegate?.detachAuth(self)
    case .none:
      break
    }
  }
}
