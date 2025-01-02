//
//  LikeCoordinator.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core

// MARK: Using Other Feature Coordinator
// step 1. get buildable when init
// step 2. build coordinator when need, and assign optional variable -> attachMethod
// step 3. release when coordinator finish, bc, optimize memory -> detachMethod

public final class LikeCoordinator: BaseCoordinator, LikeCoordinating {
  private let factory: LikeFactory

  public var finishFlow: (() -> Void)?

  public override func start() {
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
    vm.handler = handler
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.present(vc, animated: true)
  }

  public func chatRoomFlow(_ userUUID: String) {
    TFLogger.dataLogger.info("ChatRoom!")
  }
}
