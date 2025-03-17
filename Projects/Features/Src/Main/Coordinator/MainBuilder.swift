//
//  MainBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import FallingInterface
import Falling

import LikeInterface
import Like

import ChatInterface
import Chat

import MyPageInterface
import MyPage

import Auth
import AuthInterface

import ChatRoom
import ChatRoomInterface

import Domain

public final class MainBuilder: MainBuildable {
  public init() { }

  public func build() -> MainCoordinating {
    MainCoordinator(viewControllable: TFTabBarController())
  }
}
