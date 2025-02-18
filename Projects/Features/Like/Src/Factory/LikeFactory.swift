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
  private let chatRoomBuilder: ChatRoomBuildable
  private let userUseCase: UserDomainUseCaseInterface

  public init(chatRoomBuilder: ChatRoomBuildable, userUseCase: UserDomainUseCaseInterface) {
    self.chatRoomBuilder = chatRoomBuilder
    self.userUseCase = userUseCase
  }

  public func makeLikeHome() -> (ViewControllable, LikeHomeViewModel) {
    let vm = LikeHomeViewModel(likeUseCase: likeUseCase)
    let vc = LikeHomeViewController(viewModel: vm)
    return (vc, vm)
  }

  public func makeProfile(like: Like) -> (ViewControllable, LikeProfileViewModel) {

    let vm = LikeProfileViewModel(userUseCase: userUseCase, likItem: like)
    let vc = LikeProfileViewController(viewModel: vm)
    vc.modalPresentationStyle = .overFullScreen
    return (vc, vm)
  }

  public func makeChatRoomCoordinator(_ rootViewControllable: ViewControllable) -> ChatRoomCoordinating {
    let coordinator = chatRoomBuilder.build( rootViewControllable: rootViewControllable)
    return coordinator
  }
}
