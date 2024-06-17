//
//  TFLaunchViewController.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Lottie

open class TFLaunchViewController: TFBaseViewController {
  private lazy var splashLottieView = LottieAnimationView(animation: AnimationAsset.logoSplash.animation)

  public override func loadView() {
    super.loadView()
    view.backgroundColor = DSKitAsset.Color.neutral700.color
    //
    //    self.view.addSubview(splashLottieView)
    //    splashLottieView.snp.makeConstraints {
    //      $0.center.equalToSuperview()
    //    $0.height.width.equalTo(view.bounds.height * 0.7)
    //      .inset(view.bounds.height * 0.162)
    //    }
    //    splashLottieView.snp.makeConstraints {
    //      $0.centerX.equalToSuperview()
    //      $0.top.equalTo(view.safeAreaLayoutGuide)
    //      $0.height.width.equalTo(view.bounds.height * 0.7)
    //        .inset(view.bounds.height * 0.162)
    ////      $0.height.equalTo(180)
    //    }
    //
    //    splashLottieView.play()
  }
  open override func makeUI() {
    view.addSubview(splashLottieView)
    splashLottieView.contentMode = .scaleAspectFit

    splashLottieView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(10)
      //      $0.height.width.equalTo(view.bounds.height * 0.7)
      //        .inset(view.bounds.height * 0.162)
    }

    splashLottieView.play()

  }
  
  open override func navigationSetting() {
    super.navigationSetting()
    navigationController?.navigationBar.isHidden = true
  }
}
