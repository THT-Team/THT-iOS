//
//  MainCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

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
  func setViewController(_ viewControllables: [ViewControllable])
}

final class MainCoordinator: BaseCoordinator, MainCoordinating {
  var finishFlow: (() -> Void)?
  
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
  }
  
  override func start() {
    replaceWindowRootViewController(rootViewController: mainViewControllable)
    attachTab()
  }
  
  func attachTab() {
    let fallingCoordinator = fallingBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(fallingCoordinator)
    fallingCoordinator.viewControllable.uiController.tabBarItem = .makeTabItem(.falling)
    fallingCoordinator.delegate = self
    fallingCoordinator.start()
    
    let likeCoordinator = likeBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(likeCoordinator)
    likeCoordinator.viewControllable.uiController.tabBarItem = .makeTabItem(.like)
    likeCoordinator.start()
    
    let chatCoordinator = chatBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(chatCoordinator)
    chatCoordinator.viewControllable.uiController.tabBarItem = .makeTabItem(.chat)
    chatCoordinator.delegate = self
    chatCoordinator.start()
    
    let myPageCoordinator = myPageBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(myPageCoordinator)
    myPageCoordinator.viewControllable.uiController.tabBarItem = .makeTabItem(.myPage)
    myPageCoordinator.finishFlow = { [weak self] in
      self?.detachTab()
    }
    myPageCoordinator.start()
    
    let viewControllables = [
      fallingCoordinator.viewControllable,
      likeCoordinator.viewControllable,
      chatCoordinator.viewControllable,
      myPageCoordinator.viewControllable
    ]
    
    self.mainViewControllable.setViewController(viewControllables)
  }
  
  func detachTab() {
    self.childCoordinators.forEach { child in
      child.viewControllable.setViewControllers([])
      detachChild(child)
    }
    finishFlow?()
  }
}

extension MainCoordinator: FallingCoordinatorDelegate, ChatCoordinatorDelegate {
}
