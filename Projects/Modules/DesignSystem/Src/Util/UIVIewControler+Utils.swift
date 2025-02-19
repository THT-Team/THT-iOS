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
                        topActionTitle: String? = "확인",
                        bottomActionTitle: String = "취소",
                        dimColor: UIColor = DSKitAsset.Color.DimColor.default.color,
                        topActionCompletion: (() -> Void)? = nil,
                        bottomActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(titleText: title,
                                                    messageText: message,
                                                    dimColor: dimColor)
    showAlert(alertViewController: alertViewController,
              topActionTitle: topActionTitle,
              bottomActionTitle: bottomActionTitle,
              topActionCompletion: topActionCompletion,
              bottomActionCompletion: bottomActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }

  public func showAlert(contentView: UIView,
                        topActionTitle: String? = "확인",
                        bottomActionTitle: String = "취소",
                        dimColor: UIColor = DSKitAsset.Color.DimColor.default.color,
                        topActionCompletion: (() -> Void)? = nil,
                        bottomActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(contentView: contentView,
                                                    dimColor: dimColor)

    showAlert(alertViewController: alertViewController,
              topActionTitle: topActionTitle,
              bottomActionTitle: bottomActionTitle,
              topActionCompletion: topActionCompletion,
              bottomActionCompletion: bottomActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }

  public func showAlert(action: ReportAction,
                        dimColor: UIColor = DSKitAsset.Color.DimColor.default.color,
                        topActionCompletion: (() -> Void)? = nil,
                        bottomActionCompletion: (() -> Void)? = nil,
                        dimActionCompletion: (() -> Void)? = nil) {
    let alertViewController = TFAlertViewController(titleText: action.title,
                                                    messageText: action.message,
                                                    dimColor: dimColor)

    showAlert(alertViewController: alertViewController,
              topActionTitle: action.topActionTitle,
              bottomActionTitle: action.bottomActionTitle,
              topActionCompletion: topActionCompletion,
              bottomActionCompletion: bottomActionCompletion,
              dimActionCompletion: dimActionCompletion)
  }

  private func showAlert(alertViewController: TFAlertViewController,
                         topActionTitle: String?,
                         bottomActionTitle: String,
                         topActionCompletion: (() -> Void)?,
                         bottomActionCompletion: (() -> Void)?,
                         dimActionCompletion: (() -> Void)?) {
    alertViewController.addActionToButton(title: topActionTitle) { [weak alertViewController] in
      alertViewController?.dismiss(animated: false,
                                  completion: topActionCompletion)
    }

    alertViewController.addActionToButton(title: bottomActionTitle,
                                          withSeparator: true) { [weak alertViewController] in
      alertViewController?.dismiss(animated: false,
                                  completion: bottomActionCompletion)
    }

    alertViewController.addActionToDim() { [weak alertViewController] in
      alertViewController?.dismiss(animated: false,
                                  completion: dimActionCompletion)
    }

    present(alertViewController, animated: false, completion: nil)
  }
}
