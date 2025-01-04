//
//  RotateTransition.swift
//  Core
//
//  Created by Kanghos on 1/4/25.
//

import UIKit

public final class RotatateTransition: NSObject, UIViewControllerAnimatedTransitioning {

  var duration: TimeInterval {
    0.35
  }
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    guard
      let from = transitionContext.viewController(forKey: .from)
    else {
      transitionContext.completeTransition(false)
      return
    }

    let fromView = from.view

    let transfrom = CGAffineTransform(rotationAngle: -.pi / 8)
      .translatedBy(x: -100, y: 0)
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
      fromView?.transform = transfrom
      fromView?.alpha = 0.1
    } completion: { postion in
      let finished = !transitionContext.transitionWasCancelled
      transitionContext.completeTransition(finished)
    }
  }
}

