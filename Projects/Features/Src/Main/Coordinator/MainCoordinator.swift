//
//  MainCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation
import Combine

import Core

import FallingInterface
import Falling

import LikeInterface
import Like

import ChatInterface
import Chat

import MyPageInterface
import MyPage

protocol MainViewControllable: ViewControllable {
  func setViewController(_ viewControllables: [(ViewControllable)])
}

final class MainCoordinator: BaseCoordinator, MainCoordinating {
  var finishFlow: (() -> Void)?
  var cancellables = Set<AnyCancellable>()
  
  public weak var delegate: MainCoordinatorDelegate?
  private let mainViewControllable: MainViewControllable
  private let fallingBuildable: FallingBuildable
  private let likeBuildable: LikeBuildable
  private let chatBuildable: ChatBuildable
  private let myPageBuildable: MyPageBuildable
  
  init(
    viewControllable: MainViewControllable,
    fallingBuildable: FallingBuildable,
    likeBuildable: LikeBuildable,
    chatBuildable: ChatBuildable,
    myPageBuildable: MyPageBuildable
  ) {
    self.mainViewControllable = viewControllable
    self.fallingBuildable = fallingBuildable
    self.likeBuildable = likeBuildable
    self.chatBuildable = chatBuildable
    self.myPageBuildable = myPageBuildable
    
    
    super.init(viewControllable: self.mainViewControllable)
    bind()
  }
  
  override func start() {
    replaceWindowRootViewController(rootViewController: self.mainViewControllable)
    attachTab()
  }
  
  func attachTab() {
    let fallingCoordinator = fallingBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(fallingCoordinator)
    fallingCoordinator.viewControllable.uiController.tabBarItem = TabItem.falling.item
    fallingCoordinator.start()

    let likeCoordinator = likeBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(likeCoordinator)
    likeCoordinator.viewControllable.uiController.tabBarItem = TabItem.like.item
    likeCoordinator.start()

    let chatCoordinator = chatBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(chatCoordinator)
    chatCoordinator.viewControllable.uiController.tabBarItem = TabItem.chat.item
    chatCoordinator.start()

    let myPageCoordinator = myPageBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(myPageCoordinator)
    myPageCoordinator.viewControllable.uiController.tabBarItem = TabItem.myPage.item
//    myPageCoordinator.finishFlow = { [weak self, weak myPageCoordinator] in
//      self?.finishFlow?()
//      self?.detachChild(myPageCoordinator)
//    }
//    myPageCoordinator.start()

    self.mainViewControllable.setViewController([
      fallingCoordinator.viewControllable,
      likeCoordinator.viewControllable,
      chatCoordinator.viewControllable,
//      myPageCoordinator.viewControllable
    ])
  }
  
  
  func detachTab() {
    self.childCoordinators.forEach { child in
//      child.viewControllable.popToRootViewController(animated: false)
      child.viewControllable.setViewControllers([])
      detachChild(child)
    }
    finishFlow?()
  }
  
  func bind() {
    NotificationCenter.default.publisher(for: .needAuthLogout)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.finishFlow?()
        UserDefaultRepository.shared.removeUser()
        UserDefaultRepository.shared.remove(key: .token)
      }
      .store(in: &cancellables)
  }
}
