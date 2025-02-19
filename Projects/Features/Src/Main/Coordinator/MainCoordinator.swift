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
//  func setViewController(_ viewControllables: [(ViewControllable)])
}

final class MainCoordinator: BaseCoordinator, MainCoordinating {
  
  var finishFlow: (() -> Void)?
  var cancellables = Set<AnyCancellable>()

  private let mainViewControllable: MainViewControllable
  
  init(
    viewControllable: MainViewControllable
  ) {
    self.mainViewControllable = viewControllable

    super.init(viewControllable: self.mainViewControllable)
//    bind()
  }

  override func start() {
    replaceWindowRootViewController(rootViewController: self.mainViewControllable)
    childCoordinators.forEach { child in
      child.start()
    }
  }
  
  func attachTab() {

  }

  func detachTab() {

  }
}
