//
//  LaunchCoordinator.swift
//  AuthDemo
//
//  Created by Kanghos on 6/4/24.
//

import UIKit
import Core
import DSKit
import AuthInterface
import SignUpInterface

public final class AuthLaunchCoordinator: BaseCoordinator, AuthLaunchCoordinating {
  @Injected private var useCase: AuthUseCaseInterface
  @Injected private var userInfoUseCase: UserInfoUseCaseInterface
  public weak var delegate: LaunchCoordinatingDelegate?

  public override func start() {
    launchFlow()
  }

  public func launchFlow() {
    let vm = LauncherViewModel(userInfoUseCase: self.userInfoUseCase, useCase: self.useCase)
    let vc = TFAuthLauncherViewController(viewModel: vm)
    vm.delegate = self
    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension AuthLaunchCoordinator: LauncherDelegate {
  public func needAuth() {
    self.delegate?.finishFlow(self, .needAuth)
  }

  public func toMain() {
    self.delegate?.finishFlow(self, .toMain)
  }
}
