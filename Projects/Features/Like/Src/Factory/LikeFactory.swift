//
//  LikeFactory.swift
//  Like
//
//  Created by Kanghos on 1/2/25.
//

import UIKit
import DSKit
import Core

import LikeInterface
import ChatRoomInterface
import Domain

public final class LikeFactory {
  @Injected var likeUseCase: LikeUseCaseInterface
  @Injected var userUseCase: UserDomainUseCaseInterface

  private let chatRoomBuilder: ChatRoomBuildable

  public init(chatRoomBuilder: ChatRoomBuildable) {
    self.chatRoomBuilder = chatRoomBuilder
  }

  public func makeLikeHome() -> (ViewControllable, LikeHomeViewModel) {
    let vm = LikeHomeViewModel(likeUseCase: likeUseCase)
    let vc = LikeHomeViewController(viewModel: vm)
    return (vc, vm)
  }

  public func makeProfile(like: Like) -> (ViewControllable, LikeProfileViewModel) {
    let vm = LikeProfileViewModel(likeUseCase: likeUseCase, userUseCase: userUseCase, likItem: like)
    let vc = LikeProfileViewController(viewModel: vm)
    vc.modalPresentationStyle = .overFullScreen
    return (vc, vm)
  }

  public func makeChatRoomCoordinator(_ userUUID: String, _ rootViewControllable: ViewControllable) -> ChatRoomCoordinating {
    let coordinator = chatRoomBuilder.build(userUUID, rootViewControllable: rootViewControllable)
    return coordinator
  }
}
