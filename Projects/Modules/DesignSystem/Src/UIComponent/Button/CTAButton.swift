//
//  CTAButton.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/26.
//
import Core
import UIKit
import RxSwift

public struct CTABtnStyle {
  let activeTitleColor: UIColor
  let activeBackgroundColor: UIColor
  let inactiveTitleColor: UIColor
  let inactiveBackgroundColor: UIColor

  public init(activeTitleColor: UIColor, activeBackgroundColor: UIColor, inactiveTitleColor: UIColor, inactiveBackgroundColor: UIColor) {
    self.activeTitleColor = activeTitleColor
    self.activeBackgroundColor = activeBackgroundColor
    self.inactiveTitleColor = inactiveTitleColor
    self.inactiveBackgroundColor = inactiveBackgroundColor
  }
}

open class CTAButton: UIButton {
  public var style = CTABtnStyle(
    activeTitleColor: DSKitAsset.Color.neutral600.color,
    activeBackgroundColor: DSKitAsset.Color.primary500.color,
    inactiveTitleColor: DSKitAsset.Color.neutral900.color,
    inactiveBackgroundColor: DSKitAsset.Color.disabled.color
  ) {
    didSet {
      updateColors(status: false)
    }
  }

  open override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        UIView.animate(withDuration: 0.1) {
          self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }

      } else {
        UIView.animate(withDuration: 0.1) {
          self.transform = .identity
        }
      }
    }
  }
  public init(btnTitle: String, initialStatus: Bool) {
    super.init(frame: .zero)
    titleLabel?.font = .thtH5B
    setTitle(btnTitle, for: .normal)
    layer.cornerRadius = 16
    updateColors(status: initialStatus)

    self.addAction(.init { _ in
      HapticFeedbackManager.shared.triggerImpactFeedback(style: .rigid)
    }, for: .touchUpInside)
  }

  /// update CTA button color by status
  public func updateColors(status: Bool) {
    if status {
      backgroundColor = style.activeBackgroundColor
      setTitleColor(style.activeTitleColor, for: .normal)
    } else {
      backgroundColor = style.inactiveBackgroundColor
      setTitleColor(style.inactiveTitleColor, for: .normal)
    }
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Reactive where Base: CTAButton {
  public var buttonStatus: Binder<Bool> {
    return Binder(base.self) { btn, status in
      btn.updateColors(status: status)
    }
  }
}
