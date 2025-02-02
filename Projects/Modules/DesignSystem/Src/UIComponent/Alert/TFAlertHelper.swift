//
//  TFAlertHelper.swift
//  DSKit
//
//  Created by Kanghos on 1/11/25.
//

import Foundation
import Core
import Domain

public final class AlertHelper {
  public static func userReportAlert(_ viewControllable: ViewControllable, _ handler: ((UserReportAction) -> Void)?) {
    let alert = TFAlertBuilder.makeUserReportAlert(
      topAction: {
        let reportAlert = TFAlertBuilder.makeReportAlert(
          selectAction: { menu in
            handler?(.report(menu))
          },
          cancelAction: {
            handler?(.cancel)
          })
        viewControllable.present(reportAlert, animated: true)
      },
      bottomAction: {
        let blockAlert = TFAlertBuilder.makeBlockAlert(
          topAction: {
            handler?(.block)
          },
          cancelAction: {
            handler?(.cancel)
          })
        viewControllable.present(blockAlert, animated: true)
      },
      cancelAction: {
        handler?(.cancel)
      }
    )
    viewControllable.present(alert, animated: true)
  }
}
