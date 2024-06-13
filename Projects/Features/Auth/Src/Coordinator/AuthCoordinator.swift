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
  func invoke(_ action: AuthCoordinatingAction)
}

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {
  @Injected private var authUseCase: AuthUseCaseInterface
  @Injected private var userInfoUseCase: UserInfoUseCaseInterface
  
  private let signUpBuildable: SignUpBuildable
  private var signUpCoordinator: SignUpCoordinating?
  public weak var delegate: AuthCoordinatingDelegate?

  public init(signUpBuildable: SignUpBuildable, viewControllable: ViewControllable) {
    self.signUpBuildable = signUpBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    replaceWindowRootViewController(rootViewController: self.viewControllable)

    launchFlow()
  }

  
  // MARK: Launch Screen
  public func launchFlow() {
    // TODO: Launch Screen 에서 가입/인증/메인 분기 처리

    var needAuth = true
    if needAuth {
      rootFlow()
    }
  }

  // MARK: 인증 토큰 재발급 또는 가입 시
  public func rootFlow() {
    let viewModel = AuthRootViewModel()
    viewModel.delegate = self

    let viewController = AuthRootViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }

  public func phoneNumberFlow() {
    let viewModel = PhoneCertificationViewModel(useCase: authUseCase, userInfoUseCase: self.userInfoUseCase)
    viewModel.delegate = self

    let viewController = PhoneCertificationViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func snsFlow(type: SNSType) {
    switch type {
    case .normal:
      phoneNumberFlow()
    case .kakao:
      print(type.rawValue)
    case .naver:
      print(type.rawValue)
    case .google:
      print(type.rawValue)
    case .apple:
      print(type.rawValue)
    }
  }
}

extension AuthCoordinator: AuthCoordinatingActionDelegate {
  func invoke(_ action: AuthCoordinatingAction) {
    switch action {
    case let .tologinType(snsType):
      snsFlow(type: snsType)
    case let .toSignUp(phoneNum):
      attachSignUpCoordiantor()
    case .toMain:
      self.delegate?.detachAuth(self)
    }
  }
}

// MARK: SignUpCoordinator

extension AuthCoordinator {
  func attachSignUpCoordiantor() {
    if self.signUpCoordinator != nil { return }
    let coordinator = self.signUpBuildable.build()
    coordinator.delegate = self
    self.attachChild(coordinator)
    self.signUpCoordinator = coordinator

    coordinator.start()
  }
  func detachSignUpCoordinator() {
    guard let coordinator = self.signUpCoordinator else { return }
    self.detachChild(coordinator)
    self.signUpCoordinator = nil
  }
}

extension AuthCoordinator: SignUpCoordinatorDelegate {
  public func detachSignUp(_ coordinator: Coordinator) {
    self.detachSignUpCoordinator()

    self.delegate?.detachAuth(self)
  }
}

