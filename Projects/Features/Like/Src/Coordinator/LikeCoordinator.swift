//
//  LikeCoordinator.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core

enum LikeCoordinatorAction {
  case presentProfile(like: Like, listener: LikeProfileListener)
  case pushChatRoom(id: String)
  case dismissProfile
}

protocol LikeCoordinatorActionDelegate: AnyObject {
  func invoke(_ action: LikeCoordinatorAction)
}

// MARK: Using Other Feature Coordinator
// step 1. get buildable when init
// step 2. build coordinator when need, and assign optional variable -> attachMethod
// step 3. release when coordinator finish, bc, optimize memory -> detachMethod

public final class LikeCoordinator: BaseCoordinator, LikeCoordinating {
  @Injected var likeUseCase: LikeUseCaseInterface

  private let chatRoomBuildable: ChatRoomBuildable
  private var chatRoomCoordinator: ChatRoomCoordinating?

  public weak var delegate: LikeCoordinatorDelegate?

  public override func start() {
    homeFlow()
  }

  init(chatRoomBuildable: ChatRoomBuildable, viewControllable: ViewControllable) {
    self.chatRoomBuildable = chatRoomBuildable
    super.init(viewControllable: viewControllable)
  }

  func attachChatRoomCoordinator() {
    if self.chatRoomCoordinator != nil { return }
    let coordinator = chatRoomBuildable.build(rootViewControllable: self.viewControllable, listener: self)
    coordinator.chatRoomFlow()
    self.attachChild(coordinator)
    self.chatRoomCoordinator = coordinator
  }

  func detachChatRoomCoordinator() {
    guard let coordinator = self.chatRoomCoordinator else { return }
    self.viewControllable.popViewController(animated: true)

    self.detachChild(coordinator)
    self.chatRoomCoordinator = nil
  }

  public func homeFlow() {
    let viewModel = LikeHomeViewModel(likeUseCase: likeUseCase)
    viewModel.delegate = self

    let viewController = LikeHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func chatRoomFlow() {
    TFLogger.dataLogger.info("ChatRoom!")
    attachChatRoomCoordinator()
  }

  public func profileFlow(_ item: Like, listener: LikeProfileListener) {
    let viewModel = LikeProfileViewModel(likeUseCase: likeUseCase, likItem: item)
    viewModel.listener = listener
    viewModel.delegate = self

    let viewController = LikeProfileViewController(viewModel: viewModel)
    viewController.modalPresentationStyle = .currentContext
    self.viewControllable.present(viewController, animated: true)
  }
}

extension LikeCoordinator: LikeCoordinatorActionDelegate {
  func invoke(_ action: LikeCoordinatorAction) {
    switch action {
    case let .presentProfile(like, listener):
      profileFlow(like, listener: listener)
    case .pushChatRoom(let id):
      chatRoomFlow()
    case .dismissProfile:
      dismissProfile()
    }
  }

  func dismissProfile() {
    self.viewControllable.dismiss()
  }
}

extension LikeCoordinator: ChatRoomCoordinatorDelegate {
  func didFinishChatRoomCoordinator(_ coordinator: Coordinator?) {
    if let coordinator {
      detachChatRoomCoordinator()
    }
  }
}
