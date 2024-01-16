//
//  FallingCoordinator.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Core

public final class FallingCoordinator: BaseCoordinator, FallingCoordinating {
  @Injected var fallingUseCase: FallingUseCaseInterface

  public weak var delegate: FallingCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = FallingHomeViewModel(fallingUseCase: fallingUseCase)
//    viewModel.delegate = self

    let viewController = FallingHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }
  
  public func chatRoomFlow() {
//    TFLogger.dataLogger.info("ChatRoom!")
  }
//  
//  public func profileFlow(_ item: Like) {
//    let viewModel = LikeProfileViewModel(likeUseCase: likeUseCase, likItem: item)
//    viewModel.delegate = self
//
//    let viewController = LikeProfileViewController(viewModel: viewModel)
//
//    self.viewControllable.pushViewController(viewController, animated: true)
//  }
}

//extension FallingCoordinator: FallingHomeDelegate {
//  func toProfile(like: LikeInterface.Like) {
//    profileFlow(like)
//  }
//  
//  func toChatRoom(userID: String) {
//    chatRoomFlow()
//  }
//}

//extension FallingCoordinator: LikeProfileDelegate {
//  func selectNextTime(userUUID: String) {
//    viewControllable.popViewController(animated: true)
//  }
//  
//  func selectLike(userUUID: String) {
//    viewControllable.popViewController(animated: true)
//  }
//  
//  func toList() {
//    viewControllable.popViewController(animated: true)
//  }
//}
