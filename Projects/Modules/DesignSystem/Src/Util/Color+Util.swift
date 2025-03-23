//
//  Color+Util.swift
//  DSKit
//
//  Created by SeungMin on 3/23/25.
//

import SwiftUI

extension Color {
  public static let cardShadow = DSKitAsset.Color.cardShadow.swiftUIColor
  public static let chatTopicBackground = DSKitAsset.Color.chatTopicBackground.swiftUIColor
  public static let chatTopicBorder = DSKitAsset.Color.chatTopicBorder.swiftUIColor
  public static let clear = DSKitAsset.Color.clear.swiftUIColor
  public enum DimColor: Sendable {
    public static let `default` = DSKitAsset.Color.DimColor.default.swiftUIColor
    public static let loading = DSKitAsset.Color.DimColor.loading.swiftUIColor
    public static let pauseDim = DSKitAsset.Color.DimColor.pauseDim.swiftUIColor
    public static let signUpDim = DSKitAsset.Color.DimColor.signUpDim.swiftUIColor
    public static let timerDim = DSKitAsset.Color.DimColor.timerDim.swiftUIColor
  }
  public static let disabled = DSKitAsset.Color.disabled.swiftUIColor
  public enum DummyUserGradient: Sendable {
    public static let backgroundFirst = DSKitAsset.Color.DummyUserGradient.backgroundFirst.swiftUIColor
    public static let backgroundSecond = DSKitAsset.Color.DummyUserGradient.backgroundSecond.swiftUIColor
    public static let borderFirst = DSKitAsset.Color.DummyUserGradient.borderFirst.swiftUIColor
    public static let borderSecond = DSKitAsset.Color.DummyUserGradient.borderSecond.swiftUIColor
  }
  public static let error = DSKitAsset.Color.error.swiftUIColor
  public static let event = DSKitAsset.Color.event.swiftUIColor
  public static let linear0 = DSKitAsset.Color.linear0.swiftUIColor
  public static let linear1 = DSKitAsset.Color.linear1.swiftUIColor
  public static let linear2 = DSKitAsset.Color.linear2.swiftUIColor
  public enum LikeGradient: Sendable {
    public static let gradientFirst = DSKitAsset.Color.LikeGradient.gradientFirst.swiftUIColor
    public static let gradientSecond = DSKitAsset.Color.LikeGradient.gradientSecond.swiftUIColor
    public static let gradientThird = DSKitAsset.Color.LikeGradient.gradientThird.swiftUIColor
  }
  public static let neutral300 = DSKitAsset.Color.neutral300.swiftUIColor
  public static let neutral400 = DSKitAsset.Color.neutral400.swiftUIColor
  public static let neutral450 = DSKitAsset.Color.neutral450.swiftUIColor
  public static let neutral50 = DSKitAsset.Color.neutral50.swiftUIColor
  public static let neutral500 = DSKitAsset.Color.neutral500.swiftUIColor
  public static let neutral600 = DSKitAsset.Color.neutral600.swiftUIColor
  public static let neutral700 = DSKitAsset.Color.neutral700.swiftUIColor
  public static let neutral900 = DSKitAsset.Color.neutral900.swiftUIColor
  public static let pauseTitle = DSKitAsset.Color.pauseTitle.swiftUIColor
  public static let payment = DSKitAsset.Color.payment.swiftUIColor
  public static let primary300 = DSKitAsset.Color.primary300.swiftUIColor
  public static let primary400 = DSKitAsset.Color.primary400.swiftUIColor
  public static let primary500 = DSKitAsset.Color.primary500.swiftUIColor
  public static let primary600 = DSKitAsset.Color.primary600.swiftUIColor
  public static let kakaoPrimary = DSKitAsset.Color.kakaoPrimary.swiftUIColor
  public static let naverPrimary = DSKitAsset.Color.naverPrimary.swiftUIColor
  public static let thtOrange100 = DSKitAsset.Color.thtOrange100.swiftUIColor
  public static let thtOrange200 = DSKitAsset.Color.thtOrange200.swiftUIColor
  public static let thtOrange300 = DSKitAsset.Color.thtOrange300.swiftUIColor
  public static let thtOrange400 = DSKitAsset.Color.thtOrange400.swiftUIColor
  public static let thtRed = DSKitAsset.Color.thtRed.swiftUIColor
  public static let topicBackground = DSKitAsset.Color.topicBackground.swiftUIColor
  public static let topicBorder = DSKitAsset.Color.topicBorder.swiftUIColor
  public static let unSelected = DSKitAsset.Color.unSelected.swiftUIColor
  public static let blur = DSKitAsset.Color.blur.swiftUIColor
}

extension UIColor {
  public convenience init(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(rgb & 0x0000FF) / 255.0
    
    self.init(red: r, green: g, blue: b, alpha: 1.0)
  }
}

extension Color {
  public init(hex: String) {
    let uiColor = UIColor(hex: hex)
    self.init(uiColor)
  }
}
