//
//  FallingCoordinator.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Core

import DSKit
import ChatRoomInterface
import Domain

protocol TopicActionDelegate: AnyObject {
  func didTapStartButton(topic: DailyKeyword)
  func didFinishDailyTopic()
}

protocol MatchActionDelegate: AnyObject {
  func closeButtonTap()
}

public final class FallingCoordinator: BaseCoordinator, FallingCoordinating {
  @Injected var topicUseCase: TopicUseCaseInterface
  @Injected var fallingUseCase: FallingUseCaseInterface
  @Injected var userDomainUseCase: UserDomainUseCaseInterface
  @Injected var likeUseCase: LikeUseCaseInterface
  
  private let chatRoomBuilder: ChatRoomBuildable
  
  private weak var matchActionDelegate: MatchActionDelegate?
    
  public init(chatRoomBuilder: ChatRoomBuildable, viewControllable: ViewControllable) {
    self.chatRoomBuilder = chatRoomBuilder
    super.init(viewControllable: viewControllable)
  }
  
  public override func start() {
    homeFlow()
  }
  
  public func homeFlow() {
    let viewModel = FallingViewModel(
      topicUseCase: topicUseCase,
      fallingUseCase: fallingUseCase,
      userDomainUseCase: userDomainUseCase,
      likeUseCase: likeUseCase
    )
    
    viewModel.onReport = { [weak viewControllable] handler in
      guard let viewControllable else { return }
      AlertHelper.userReportAlert(viewControllable, handler)
    }
    
    viewModel.onMatch = { [weak self] url, nickname, index in
      self?.toMatchFlow(url, nickname: nickname, index: index)
    }
    
    viewModel.onTopicBottomSheet = { [weak self] topicExpirationUnixTime in
      self?.toTopicBottomSheetFlow(topicExpirationUnixTime: topicExpirationUnixTime)
    }
    
    let viewController = FallingViewController(viewModel: viewModel)
    matchActionDelegate = viewController as any MatchActionDelegate
    
    self.viewControllable.setViewControllers([viewController])
  }
  
  public func chatRoomFlow(_ index: String) {
    TFLogger.dataLogger.info("ChatRoom!")
    let coordinator = chatRoomBuilder.build(rootViewControllable: viewControllable)
    
    coordinator.finishFlow = { [weak self, weak coordinator] message in
      guard let self, let coordinator else { return }
      coordinator.childCoordinators.removeAll()
      self.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.chatRoomFlow(index)
  }
  
  public func toMatchFlow(_ imageURL: String, nickname: String, index: String) {
    let vc = MatchViewController(
      imageURL,
      nickname: nickname,
      index: index
    )
    
    vc.onCancel = { [weak self] in
      guard let self = self else { return }
      self.viewControllable.dismiss()
      self.matchActionDelegate?.closeButtonTap()
    }
    
    vc.onClick = { [weak self] index in
      guard let self = self else { return }
      self.viewControllable.dismiss()
      self.matchActionDelegate?.closeButtonTap()
      self.chatRoomFlow(index)
    }
    
    vc.uiController.modalTransitionStyle = .crossDissolve
    vc.uiController.modalPresentationStyle = .overFullScreen
    viewControllable.present(vc, animated: true)
  }
  
  public func toTopicBottomSheetFlow(topicExpirationUnixTime: Date) {
    let viewModel = TopicBottomSheetViewModel(topicExpirationUnixTime: topicExpirationUnixTime)
    let vc = TFBaseHostingController(rootView: TopicBottomSheetView(viewModel: viewModel))
    vc.uiController.modalPresentationStyle = .pageSheet
    
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [
        .custom(identifier: .init("fixed-396")) { _ in 396 },
      ]
      sheet.prefersGrabberVisible = false
      sheet.preferredCornerRadius = 20
    }
    
    viewControllable.present(vc, animated: true)
  }
}
