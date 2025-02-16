//
//  Window+Toast.swift
//  DSKit
//
//  Created by SeungMin on 2/16/25.
//

import Foundation
import UIKit

public struct ToastStorage {
  public static var shared = ToastStorage()
  
  private init() { }
  
  public var toastViews: [String: AnyObject] = [:]
}

extension UIWindow {
  public func makeToast(
    _ view: UIView,
    duration: TimeInterval,
    position: TFToast.Position,
    inset: UIEdgeInsets
  ) {
    let id = UUID().uuidString
    ToastStorage.shared.toastViews[id] = view
    
    view.alpha = 0.0
    
    addSubview(view)
    
    view.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(inset.left)
      make.trailing.equalToSuperview().inset(inset.right)
      switch position {
      case .top:
        make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(inset.top)
      case .bottom:
        make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-inset.bottom)
      }
    }
    
    view.addGestureRecognizer(
      BindableTapGestureRecognizer { [weak self] in
        self?.removeToast(id: id)
      }
    )
    
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
      completion: { [weak self, weak view] _ in
        guard let self = self, let view = view else { return }
        if duration > 0 {
          UIView.animate(
            withDuration: 0.3,
            delay: duration,
            options: [.allowUserInteraction],
            animations: { [weak view] in
              guard let view = view else { return }
              view.alpha = 0.05
            },
            completion: { [weak self] _ in
              guard let self = self else { return }
              self.removeToast(id: id)
            }
          )
        }
      }
    )
  }
  
  public func removeToast(id: String) {
    guard let view = ToastStorage.shared.toastViews[id] as? UIView else { return }
    view.removeFromSuperview()
    ToastStorage.shared.toastViews[id] = nil
  }
}
