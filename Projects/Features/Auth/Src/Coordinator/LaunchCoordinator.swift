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

  public var finishFlow: ((LaunchAction) -> Void)?

  public override func start() {
    launchFlow()
  }

  public func launchFlow() {
    replaceWindowRootViewController(rootViewController: self.viewControllable)
    let vm = LauncherViewModel(useCase: self.useCase)
    let vc = TFAuthLauncherViewController(viewModel: vm)

    vm.onAuthResult = { [weak self] result in
      self?.finishFlow?(result)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }
}
