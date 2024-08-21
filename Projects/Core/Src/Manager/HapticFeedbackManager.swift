//
//  HapticFeedbackManager.swift
//  Core
//
//  Created by Kanghos on 8/2/24.
//

import Foundation
import UIKit

public class HapticFeedbackManager {
    public static let shared = HapticFeedbackManager()

    private init() {}

    public func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    public func triggerSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
