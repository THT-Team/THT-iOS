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

  private let chatRoomBuilder: ChatRoomBuildable
  private let userUseCase: UserDomainUseCaseInterface
  private let likeUseCase: LikeUseCaseInterface

  public init(
    chatRoomBuilder: ChatRoomBuildable,
    userUseCase: UserDomainUseCaseInterface,
    likeUseCase: LikeUseCaseInterface
  ) {
    self.chatRoomBuilder = chatRoomBuilder
    self.userUseCase = userUseCase
    self.likeUseCase = likeUseCase
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
