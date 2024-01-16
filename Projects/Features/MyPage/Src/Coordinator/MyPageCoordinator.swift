//
//  MyPageCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import Core

public final class MyPageCoordinator: BaseCoordinator, MyPageCoordinating {
  @Injected var myPageUseCase: MyPageUseCaseInterface

  public weak var delegate: MyPageCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = MyPageHomeViewModel(myPageUseCase: myPageUseCase)
//    viewModel.delegate = self

    let viewController = MyPageHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }
}

