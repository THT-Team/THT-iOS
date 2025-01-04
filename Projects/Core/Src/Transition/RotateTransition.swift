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

    let width = transitionContext.containerView.frame.width
    let xPosition: CGFloat = width * -170 / 390
    let transfrom = CGAffineTransform(rotationAngle: -.pi / 12)
      .translatedBy(x: xPosition, y: 0)
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
      fromView?.transform = transfrom
      fromView?.alpha = 0.5
    } completion: { postion in
      let finished = !transitionContext.transitionWasCancelled
      transitionContext.completeTransition(finished)
    }
  }
}

