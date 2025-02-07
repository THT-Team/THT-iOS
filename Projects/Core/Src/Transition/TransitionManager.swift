//
//  TransitionManager.swift
//  Core
//
//  Created by Kanghos on 1/4/25.
//

import UIKit

public final class TransitionManager: NSObject {
  public static let shared = TransitionManager()
  private override init() { super.init() }

  private var transition: UIViewControllerAnimatedTransitioning?
  public var modalTransition: UIViewControllerAnimatedTransitioning?
}

extension TransitionManager: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
    return self.transition
  }
}

extension TransitionManager: UIViewControllerTransitioningDelegate {
  public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
    modalTransition
  }
}
