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
  @Injected var likeUseCase: LikeUseCaseInterface

  public weak var delegate: LikeCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = LikeHomeViewModel(likeUseCase: likeUseCase)
    viewModel.delegate = self

    let viewController = LikeHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }
  
  public func chatRoomFlow() {
    TFLogger.dataLogger.info("ChatRoom!")
  }
  
  public func profileFlow(_ item: Like) {
    let viewModel = LikeProfileViewModel(likeUseCase: likeUseCase, likItem: item)
    viewModel.delegate = self

    let viewController = LikeProfileViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }
}

extension LikeCoordinator: LikeHomeDelegate {
  func toProfile(like: LikeInterface.Like) {
    profileFlow(like)
  }
  
  func toChatRoom(userID: String) {
    chatRoomFlow()
  }
}

extension LikeCoordinator: LikeProfileDelegate {
  func selectNextTime(userUUID: String) {
    viewControllable.popViewController(animated: true)
  }
  
  func selectLike(userUUID: String) {
    viewControllable.popViewController(animated: true)
  }
  
  func toList() {
    viewControllable.popViewController(animated: true)
  }
}
