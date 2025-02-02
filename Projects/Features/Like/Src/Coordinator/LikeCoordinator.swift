//
//  LikeCoordinator.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import LikeInterface

import Core
import Domain
import DSKit

// MARK: Using Other Feature Coordinator
// step 1. get buildable when init
// step 2. build coordinator when need, and assign optional variable -> attachMethod
// step 3. release when coordinator finish, bc, optimize memory -> detachMethod

public typealias LikeProfileHandler = ((LikeProfileAction) -> Void)

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

  public func profileFlow(_ item: Like, handler: LikeProfileHandler?) {
    let (vc, vm) = factory.makeProfile(like: item)
    TransitionManager.shared.modalTransition = nil

    vm.onDismiss = { [weak self] needTransition in
      TransitionManager.shared.modalTransition = needTransition
      ? RotatateTransition() : nil
      self?.viewControllable.dismiss()
    }

    vm.onHandleLike = { action in
      handler?(action)
    }

    vm.onReport = { [weak viewControllable] handler in
      guard let viewControllable else { return }
      AlertHelper.userReportAlert(viewControllable, handler)
    }
//    // TODO: make Proxy ref - ribs
    vc.uiController.transitioningDelegate = TransitionManager.shared
    self.viewControllable.present(vc, animated: true)
  }

  public func chatRoomFlow(_ userUUID: String) {
    TFLogger.dataLogger.info("ChatRoom - \(userUUID)!")
    var coordinator = factory.makeChatRoomCoordinator(userUUID, self.viewControllable)
    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let self, let coordinator else { return }
      coordinator.childCoordinators.removeAll()
      self.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.chatRoomFlow(userUUID)
  }
}
