//
//  LineSpacing.swift
//  DSKit
//
//  Created by SeungMin on 3/23/25.
//

import Foundation
import SwiftUI

public struct PretendardFontModifier: ViewModifier {
  var weight: AppFont.Pretendard.Weight
  var size: CGFloat
  var lineSpacingPercent: CGFloat
  var letterSpacingPercent: CGFloat
  
  public init(
    weight: AppFont.Pretendard.Weight,
    size: CGFloat,
    lineSpacingPercent: CGFloat,
    letterSpacingPercent: CGFloat = -2
  ) {
    self.weight = weight
    self.size = size
    self.lineSpacingPercent = lineSpacingPercent
    self.letterSpacingPercent = letterSpacingPercent
  }
  
  public init(
    weight: Int,
    size: CGFloat,
    lineSpacingPercent: CGFloat,
    letterSpacingPercent: CGFloat = -2
  ) {
    self.weight = .init(rawValue: weight)!
    self.size = size
    self.lineSpacingPercent = lineSpacingPercent
    self.letterSpacingPercent = letterSpacingPercent
  }
  
  public func body(content: Content) -> some SwiftUI.View {
    let lineHeight = size * (lineSpacingPercent / 100)
    
    content
      .font(.pretendard(weight: weight, size: size))
      .lineSpacing(lineHeight - size)
      .tracking(size * (letterSpacingPercent / 100))
      .padding(.vertical, (lineHeight - size) / 2)
  }
}

public extension SwiftUI.View {
  func font(
    weight: AppFont.Pretendard.Weight,
    size: CGFloat,
    lineSpacingPercent: CGFloat,
    letterSpacingPercent: CGFloat = -2
  ) -> some SwiftUI.View {
    modifier(
      PretendardFontModifier(
        weight: weight,
        size: size,
        lineSpacingPercent: lineSpacingPercent,
        letterSpacingPercent: letterSpacingPercent
      )
    )
  }
  
  func font(
    weight: Int,
    size: CGFloat,
    lineSpacingPercent: CGFloat,
    letterSpacingPercent: CGFloat = -2
  ) -> some SwiftUI.View {
    modifier(
      PretendardFontModifier(
        weight: weight,
        size: size,
        lineSpacingPercent: lineSpacingPercent,
        letterSpacingPercent: letterSpacingPercent
      )
    )
  }
}

public enum AppFont {
  public enum Pretendard {
    public enum Weight: Int {
//      case thin = 100
//      case extraLight = 200
//      case light = 300
      case regular = 400
      case medium = 500
      case semibold = 600
      case bold = 700
      case extrabold = 800
//      case heavy = 900
      
      var converter: DSKitFontConvertible {
        switch self {
//        case .thin: "Thin"
//        case .extraLight: "ExtraLight"
//        case .light: "Light"
        case .regular: DSKitFontFamily.Pretendard.regular
        case .medium: DSKitFontFamily.Pretendard.medium
        case .semibold: DSKitFontFamily.Pretendard.semiBold
        case .bold: DSKitFontFamily.Pretendard.bold
        case .extrabold: DSKitFontFamily.Pretendard.extraBold
//        case .heavy: "Heavy"
        }
      }
    }
  }
}


public extension Font {
  static func pretendard(
    weight: AppFont.Pretendard.Weight,
    size: CGFloat
  ) -> Font {
    return weight.converter.swiftUIFont(size: size)
  }
  
  static func pretendard(
    weight: Int,
    size: CGFloat
  ) -> Font {
    return AppFont.Pretendard.Weight(rawValue: weight)!.converter.swiftUIFont(size: size)
  }
}
