//
//  MainCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

import LikeInterface
import Like

protocol MainViewControllable: ViewControllable {
  func setViewController(_ viewControllables: [ViewControllable])
}

final class MainCoordinator: BaseCoordinator, MainCoordinating {
  
  public weak var delegate: MainCoordinatorDelegate?
  private let mainViewControllable: MainViewControllable
  private let likeBuildable: LikeBuildable
  init(
    viewControllable: MainViewControllable,
    likeBuildable: LikeBuildable
  ) {
    self.mainViewControllable = viewControllable
    self.likeBuildable = likeBuildable

    super.init(viewControllable: self.mainViewControllable)
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  override func start() {
    attachTab()
  }

  func attachTab() {

    let likeCoordinator = likeBuildable.build(rootViewControllable: NavigationViewControllable())
    attachChild(likeCoordinator)
    likeCoordinator.start()
    likeCoordinator.delegate = self

    let viewControllables = [
      likeCoordinator.viewControllable
    ]
    self.mainViewControllable.setViewController(viewControllables)
  }
  
  func detachTab() {
    delegate?.detachTab(self)
  }
}

extension MainCoordinator: LikeCoordinatorDelegate {
  func test(_ coordinator: Core.Coordinator) {
    self.delegate?.detachTab(self)
  }
}
