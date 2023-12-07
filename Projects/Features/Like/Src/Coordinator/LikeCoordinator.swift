//
//  LikeCoordinator.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core

public final class LikeCoordinator: BaseCoordinator, LikeCoordinating {
  public weak var delegate: LikeCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    TFLogger.ui.debug(#function)
    
    let viewModel = LikeHomeViewModel()
    viewModel.delegate = self

    let viewController = LikeHomeViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }
  
  public func chatRoomFlow() {

  }
  
  public func detailFlow() {

  }
}

extension LikeCoordinator: LikeHomeDelegate {
  public func deinitTest() {
    self.delegate?.test(self)
  }
}
