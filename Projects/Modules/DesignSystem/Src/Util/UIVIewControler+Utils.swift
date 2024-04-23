//
//  UIVIewControler+Utils.swift
//  DSKit
//
//  Created by SeungMin on 4/17/24.
//

import UIKit

extension UIViewController {
  public func showAlert(title: String? = nil,
                        message: String? = nil,
                        attributedMessage: NSAttributedString? = nil,
                        leftActionTitle: String? = "확인",
                        rightActionTitle: String = "취소",
                        leftActionCompletion: (() -> Void)? = nil,
                        rightActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(titleText: title,
                                                    messageText: message)
    showAlert(alertViewController: alertViewController,
              leftActionTitle: leftActionTitle,
              rightActionTitle: rightActionTitle,
              leftActionCompletion: leftActionCompletion,
              rightActionCompletion: rightActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }
  
  public func showAlert(contentView: UIView,
                        leftActionTitle: String? = "확인",
                        rightActionTitle: String = "취소",
                        leftActionCompletion: (() -> Void)? = nil,
                        rightActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(contentView: contentView)
    
    showAlert(alertViewController: alertViewController,
              leftActionTitle: leftActionTitle,
              rightActionTitle: rightActionTitle,
              leftActionCompletion: leftActionCompletion,
              rightActionCompletion: rightActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }
  
  public func showAlert(action: ReportAction,
                        leftActionCompletion: (() -> Void)? = nil,
                        rightActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(
      titleText: action.title,
      messageText: action.message
    )
    
    showAlert(alertViewController: alertViewController,
              leftActionTitle: action.leftActionTitle,
              rightActionTitle: action.rightActionTitle,
              leftActionCompletion: leftActionCompletion,
              rightActionCompletion: rightActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }
  
  private func showAlert(alertViewController: TFAlertViewController,
                         leftActionTitle: String?,
                         rightActionTitle: String,
                         leftActionCompletion: (() -> Void)?,
                         rightActionCompletion: (() -> Void)?,
                         dimActionCompletion: (() -> Void)?) {
    alertViewController.addActionToButton(title: leftActionTitle) {
      alertViewController.dismiss(animated: false, completion: leftActionCompletion)
    }
    
    alertViewController.addActionToButton(title: rightActionTitle) {
      alertViewController.dismiss(animated: false, completion: rightActionCompletion)
    }
    
    alertViewController.addActionToDim() {
      alertViewController.dismiss(animated: false, completion: dimActionCompletion)
    }
    
    present(alertViewController, animated: false, completion: nil)
  }
}
