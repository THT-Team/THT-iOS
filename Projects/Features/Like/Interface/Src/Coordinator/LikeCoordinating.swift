//
//  LikeCoordinating.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol LikeCoordinatorDelegate: AnyObject {

}

public protocol LikeProfileListener: AnyObject {
  func likeProfileDidTapReject(_ like: Like)
  func likeProfileDidTapChat(_ like: Like)
}

public protocol LikeCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()
  func chatRoomFlow(_ userUUID: String)
}

public enum LikeCoordinatorAction {
  case Home
  case Profile(item: Like)
  case chatRoom
  case meetMoody
  case backBtnTap
  case toRejectBtnTap
  case toChatBtnTap
}

public protocol LikeCoordinatingAction: AnyObject {
  func action(_ action: LikeCoordinatorAction)
}
