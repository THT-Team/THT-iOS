//
//  LikeCoordinator.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core
import UIKit

// MARK: Using Other Feature Coordinator
// step 1. get buildable when init
// step 2. build coordinator when need, and assign optional variable -> attachMethod
// step 3. release when coordinator finish, bc, optimize memory -> detachMethod

public final class LikeCoordinator: BaseCoordinator, LikeCoordinating {
  private let factory: LikeFactory

  public var finishFlow: (() -> Void)?

  public override func start() {
    (self.viewControllable.uiController as? UINavigationController)?.delegate = TransitionManager.shared
    homeFlow()
  }

  public init(factory: LikeFactory, viewControllable: ViewControllable) {
    self.factory = factory
    super.init(viewControllable: viewControllable)
  }

  public func homeFlow() {
    let (vc, vm) = factory.makeLikeHome()

    vm.onProfile = { [weak self] like, handler in
      self?.profileFlow(like, handler: handler)
    }
    vm.onChatRoom = { [weak self] userUUID in
      self?.chatRoomFlow(userUUID)
    }
    self.viewControllable.setViewControllers([vc])
  }

  public func profileFlow(_ item: Like, handler: ((LikeCellButtonAction) -> Void)?) {
    let (vc, vm) = factory.makeProfile(like: item)
    vm.onDismiss = { [weak self] action in
      if case .reject = action {
        TransitionManager.shared.modalTransition = RotatateTransition()
      } else {
        TransitionManager.shared.modalTransition = nil
      }
      self?.viewControllable.dismiss()
      handler?(action)
    }
//    // TODO: make Proxy ref - ribs
    vc.uiController.transitioningDelegate = TransitionManager.shared
    self.viewControllable.present(vc, animated: true)
  }

  public func chatRoomFlow(_ userUUID: String) {
    TFLogger.dataLogger.info("ChatRoom!")
  }
}
