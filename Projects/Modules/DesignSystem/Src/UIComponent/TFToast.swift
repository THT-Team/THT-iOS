//
//  TFToast.swift
//  DSKit
//
//  Created by SeungMin on 4/29/24.
//

import Foundation
import UIKit

@MainActor
public final class TFToast {
  
  public enum Position {
    case top, bottom
  }
  
  public static let shared: TFToast = .init()
  
  private init() { }
  
  public func show(
    view: UIView,
    duration: TimeInterval,
    position: Position,
    inset: UIEdgeInsets
  ) {
    guard let window = UIWindow.keyWindow else { return }
    window.makeToast(view, duration: duration, position: position, inset: inset)
  }
  
  public func show(
    view: UIView,
    superview: UIView,
    targetview: UIView,
    duration: TimeInterval,
    position: Position,
    inset: UIEdgeInsets
  ) {
    view.alpha = 0.0
    
    superview.addSubview(view)
    view.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(inset.left)
      make.trailing.equalToSuperview().inset(inset.right)
      switch position {
      case .top:
        make.top.equalTo(targetview.snp.bottom).offset(inset.top)
      case .bottom:
        make.bottom.equalTo(targetview.snp.top).offset(-inset.bottom)
      }
    }
    
//    view.setNeedsLayout()
//    view.layoutIfNeeded()
    
    UIView.animate(
      withDuration: 0.3,
      delay: 0.0,
      options: [.allowUserInteraction],
      animations: { [weak view] in
        guard let view = view else { return }
        view.alpha = 1.0
      },
      completion: { [weak view] _ in
        guard let view = view else { return }
        if duration > 0 {
          UIView.animate(
            withDuration: 0.3,
            delay: duration,
            options: [.allowUserInteraction],
            animations: { [weak view] in
              guard let view = view else { return }
              view.alpha = 0.05
            },
            completion: { [weak view] _ in
              guard let view = view else { return }
              view.removeFromSuperview()
            }
          )
        }
      }
    )
  }
  
  public func show(
    message: String,
    duration: TimeInterval = 3.0,
    position: Position = .bottom,
    inset: UIEdgeInsets = UIEdgeInsets(top: 68, left: 24, bottom: 24, right: 24)
  ) {
    let toastView = UIToastView()
    toastView.titleLabel.text = message
    show(
      view: toastView,
      duration: duration,
      position: position,
      inset: inset
    )
  }
  
  public func show(
    message: String,
    superview: UIView,
    targetview: UIView,
    duration: TimeInterval = 3.0,
    position: Position = .bottom,
    inset: UIEdgeInsets = UIEdgeInsets(top: 68, left: 24, bottom: 24, right: 24)
  ) {
    let toastView = UIToastView()
    toastView.titleLabel.text = message
    show(
      view: toastView,
      superview: superview,
      targetview: targetview,
      duration: duration,
      position: position,
      inset: inset
    )
  }
}

private final class UIToastView: UIView {
  let titleLabel = UILabel().then {
    $0.font = .thtP2Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.textAlignment = .center
    $0.contentMode = .scaleToFill
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(12)
      make.horizontalEdges.equalToSuperview().inset(24)
    }
    
    self.addGestureRecognizer(
      BindableTapGestureRecognizer { [weak self] in
        self?.removeFromSuperview()
      }
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    backgroundColor = DSKitAsset.Color.neutral900.color
    layer.borderWidth = 1
    layer.borderColor = DSKitAsset.Color.neutral600.color.cgColor
    layer.cornerRadius = 58 / 2
    layer.shadowColor =  DSKitAsset.Color.DimColor.signUpDim.color.cgColor
    layer.shadowOffset = CGSize(width: 2, height: 2)
    layer.shadowRadius = 16 / 2
    layer.shadowOpacity = 1.0
    layer.masksToBounds = false
  }
}

extension TFToast: ReactiveCompatible { }

extension Reactive where Base: TFToast {
  public var makeToast: Binder<String> {
    Binder(self.base) { base, value in
      DispatchQueue.main.async {
        base.show(message: value)
      }
    }
  }
}
