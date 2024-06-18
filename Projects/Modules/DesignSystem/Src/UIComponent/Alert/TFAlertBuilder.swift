//
//  TFAlertBuilder.swift
//  DSKit
//
//  Created by Kanghos on 6/18/24.
//

import Foundation

import Core

public final class TFAlertBuilder {
  // MARK: Domain에 종속된 Component 대신 추상화하기

  public static func makeUserReportAlert(
    listener: ReportAlertListener
  ) -> TFAlertViewController {
    let contentView = TFUserAlertContentView()

    let alert = TFAlertViewController(contentView: contentView, dimColor: DSKitAsset.Color.clear.color)

    contentView.didSelectMenu = { menu in
      alert.dismiss(animated: false) {
        listener.didTapAction(.didTap(menu))
      }
    }

    alert.addActionToButton(title: "취소", withSeparator: true) {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }

    alert.addActionToDim {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }
    return alert
  }

  public static func makeBlockOrReportAlert(
    listener: BlockOrReportAlertListener
  ) -> TFAlertViewController {
    let alert = TFAlertViewController()
    alert.addActionToButton(title: "신고하기") {
      alert.dismiss(animated: false) {
        listener.didTapAction(.report)
      }
    }
    alert.addActionToButton(title: "차단하기", withSeparator: true) {
      alert.dismiss(animated: false) {
        listener.didTapAction(.block)
      }
    }

    alert.addActionToDim {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }
    return alert
  }

  public static func makeBlockAlert(listener: BlockAlertListener) -> TFAlertViewController {
    let alert = TFAlertViewController(
      titleText: "차단할까요?",
      messageText: "해당 사용자와 서로 차단됩니다.",
      dimColor: DSKitAsset.Color.clear.color
    )

    alert.addActionToButton(title: "차단하기") {
      alert.dismiss(animated: false) {
        listener.didTapAction(.block)
      }
    }

    alert.addActionToButton(title: "취소", withSeparator: true) {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }

    alert.addActionToDim {
      alert.dismiss(animated: false) {
        listener.didTapAction(.cancel)
      }
    }

    return alert
  }
}
