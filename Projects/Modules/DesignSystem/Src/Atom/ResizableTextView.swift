//
//  ResizableTextView.swift
//  SignUp
//
//  Created by kangho lee on 4/27/24.
//

import UIKit

public class ResizableTextView: UITextView {
  let minimumHeight: CGFloat = 40
  let maximumHeight: CGFloat = 120

  private var cachedHeight: CGFloat = 0

  public func calculate() {
    let newHeight = calculateHeight()
    if cachedHeight != newHeight {
      invalidateIntrinsicContentSize()
      cachedHeight = newHeight
    }
  }

  private func calculateHeight() -> CGFloat {
    let fitted = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    return min(maximumHeight, max(minimumHeight, fitted.height))
  }

  public override var intrinsicContentSize: CGSize {
    let newHeight = calculateHeight()
    self.isScrollEnabled = newHeight == maximumHeight
    return CGSize(width: UIView.noIntrinsicMetric, height: newHeight)
  }
}
