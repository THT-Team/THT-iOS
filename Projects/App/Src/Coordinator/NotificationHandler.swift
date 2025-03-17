//
//  NotificationHandler.swift
//  Application
//
//  Created by Kanghos on 3/16/25.
//  Copyright © 2025 tht. All rights reserved.
//

import UIKit
import Core

import FirebaseMessaging

final class NotificationHandler: NSObject {

  func registerForRemoteNotifications() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.requestAuthorization(options: options) { granted, error in
      guard granted else { return }

      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  func registerFirebaseMessaging() {
    Messaging.messaging().delegate = self
  }

  func unregisterRemoteNotifications() {
    UIApplication.shared.unregisterForRemoteNotifications()
  }
}

extension NotificationHandler: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .list, .badge, .sound])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

extension NotificationHandler: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    TFLogger.dataLogger.info("FCM token: \(String(describing: fcmToken))")
  }
}
