//
//  ProgressNavigationControllable.swift
//  SignUp
//
//  Created by Kanghos on 7/31/24.
//

import UIKit
import Core

public protocol StageProgressable {
  var stage: Float { get set }
  var totalStage: Float { get }
}
public extension StageProgressable {
  var totalStage: Float { 12 }
  var currentStage: Float { stage / totalStage }
}

public final class ProgressNavigationViewControllable: ViewControllable {
  public var uiController: UIViewController { self.navigationController }
  public let navigationController: ProgressNavigationControllable

  public init(rootViewControllable: ViewControllable) {
    let navigationController = ProgressNavigationControllable(root: rootViewControllable)
    self.navigationController = navigationController
  }

  public init() {
    let navigationController = ProgressNavigationControllable()
    self.navigationController = navigationController
  }
}

public final class ProgressNavigationControllable: UINavigationController {
  private let progressBar = UIProgressView.makeSignUpProgress()


  public init(root: ViewControllable) {
    super.init(rootViewController: root.uiController)
    makeUI()
    self.delegate = self
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    makeUI()
    self.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeUI() {
    self.view.addSubview(progressBar)
//    self.navigationBar.addSubview(progressBar)
    self.navigationBar.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 4))
    self.navigationBar.setNeedsLayout()
    progressBar.isHidden = true
    progressBar.alpha = 0

    progressBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(4)
    }
  }
}

extension ProgressNavigationControllable: UINavigationControllerDelegate {

  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
    if let vc = viewController as? StageProgressable {
      if self.progressBar.isHidden {
        UIView.animate(withDuration: 2, delay: 0.5) {
          self.progressBar.isHidden = false
        }
      } else {
        DispatchQueue.main.async {
          self.progressBar.setProgress(vc.currentStage, animated: true)
        }
      }
    } else {
      self.progressBar.setProgress(0, animated: true)
      self.progressBar.alpha = 0
      self.progressBar.isHidden = true
    }
  }

  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if let progressVC = viewController as? StageProgressable {
      if self.progressBar.alpha == 0 {
        UIView.animate(withDuration: 0.3) {
          self.progressBar.alpha = 1
        }
        self.progressBar.setProgress(progressVC.currentStage, animated: true)
      }
    }
  }
}

extension UIProgressView {
  static func makeSignUpProgress() -> UIProgressView {
    let progress = UIProgressView(progressViewStyle: .bar)
    progress.trackTintColor = DSKitAsset.Color.disabled.color
    progress.progressTintColor = DSKitAsset.Color.primary500.color
    return progress
  }
}
