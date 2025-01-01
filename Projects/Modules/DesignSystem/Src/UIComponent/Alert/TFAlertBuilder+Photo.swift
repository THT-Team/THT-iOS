//
//  TFAlertBuilder+Photo.swift
//  DSKit
//
//  Created by kangho lee on 7/24/24.
//

import Foundation

import Core

public extension TFAlertBuilder {
  static func makePhotoEditOrDeleteAlert(
    listener: TopBottomAlertListener
  ) -> TFAlertViewController {
    let alert = TFAlertViewController()
    alert.addActionToButton(title: "사진 변경") {
      alert.dismiss(animated: false) {
        listener.didTapAction(.top)
      }
    }
    alert.addActionToButton(title: "사진 삭제", withSeparator: true) {
      alert.dismiss(animated: false) {
        listener.didTapAction(.bottom)
      }
    }
    
    alert.addActionToDim {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }
    return alert
  }

  static func makePhotoEditAlert(_ handler: TopBottomAlertHandler) -> TFAlertViewController {
    let alert = TFAlertViewController()
    alert.addActionToButton(title: "사진 변경") {
      alert.dismiss(animated: false) {
        handler?(.top)
      }
    }
    alert.addActionToButton(title: "사진 삭제", withSeparator: true) {
      alert.dismiss(animated: false) {
        handler?(.bottom)
      }
    }

    alert.addActionToDim {
      alert.dismiss(animated: false) {
        handler?(.cancel)
      }
    }
    return alert
  }
}
