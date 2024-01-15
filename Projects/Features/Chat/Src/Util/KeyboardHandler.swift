//
//  KeyboardHandler.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

public protocol KeyboardHandler: AnyObject {
  func start()
  func stop()
}

//https://github.com/GetStream/stream-chat-swift/blob/develop/Sources/StreamChatUI/Composer/ComposerKeyboardHandler.swift
public class DefaultKeyboardHandler: KeyboardHandler {
  public weak var parentVC: UIViewController?
  public weak var bottomConstraint: NSLayoutConstraint?

  public let defaultBottomConstraintValue: CGFloat

  public init(
    parentVC: UIViewController?,
    bottomConstraint: NSLayoutConstraint?
    ) {
    self.parentVC = parentVC
    self.bottomConstraint = bottomConstraint
      self.defaultBottomConstraintValue = bottomConstraint?.constant ?? 0
  }

  open func start() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrameNotification),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrameNotification),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }

  open func stop() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  open func keyboardWillChangeFrameNotification(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
          let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
          let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
          let parentView = parentVC?.view else {
      return
    }

    let isHidingKeyboard = notification.name == UIResponder.keyboardWillHideNotification
    if isHidingKeyboard {
      bottomConstraint?.constant = defaultBottomConstraintValue
    } else {
      let convertedKeyboardFrame = parentView.convert(frame, from: UIScreen.main.coordinateSpace)
      let interesectedKeyboardHeight = parentView.bounds.intersection(convertedKeyboardFrame).height

      let rootTabBar = parentView.window?.rootViewController?.tabBarController?.tabBar
      let shouldAddTabBarHeight = rootTabBar != nil && rootTabBar!.isTranslucent == false
      let rootTabBarHeight = shouldAddTabBarHeight ? rootTabBar!.frame.height : 0

      bottomConstraint?.constant = -(
        interesectedKeyboardHeight + defaultBottomConstraintValue + rootTabBarHeight - parentView.safeAreaInsets.bottom
      )
    }

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: UIView.AnimationOptions(rawValue: curve << 16)) { 
        parentView.layoutIfNeeded()
      }
  }
}

