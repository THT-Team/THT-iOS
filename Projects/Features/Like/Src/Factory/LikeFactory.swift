//
//  LikeFactory.swift
//  Like
//
//  Created by Kanghos on 1/2/25.
//

import UIKit
import DSKit

import LikeInterface

public final class LikeFactory {
  @Injected var likeUseCase: LikeUseCaseInterface

  public func makeLikeHome() -> (ViewControllable, LikeHomeViewModel) {
    let vm = LikeHomeViewModel(likeUseCase: likeUseCase)
    let vc = LikeHomeViewController(viewModel: vm)
    return (vc, vm)
  }

  public func makeProfile(like: Like) -> (ViewControllable, LikeProfileViewModel) {
    let vm = LikeProfileViewModel(likeUseCase: likeUseCase, likItem: like)
    let vc = LikeProfileViewController(viewModel: vm)
    vc.modalPresentationStyle = .overFullScreen
    return (vc, vm)
  }
}
