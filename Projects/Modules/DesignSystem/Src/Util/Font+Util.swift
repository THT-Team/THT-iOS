//
//  Font+Util.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

// Regular : weight = 400
// Meduim : weight = 500
// SemiBold : weight = 600
// Bold : weight = 700
// ExtraBold : weight = 800

public extension UIFont {
  /// Regular - size : 30 weight : 400
  static let thtH1R = DSKitFontFamily.Pretendard.regular.font(size: 30)
  /// Meduim - size : 30 weight : 500
  static let thtH1M = DSKitFontFamily.Pretendard.medium.font(size: 30)
  /// SemiBold - size : 30 weight : 600
  static let thtH1Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 30)
  /// Bold - size : 30 weight : 700
  static let thtH1B = DSKitFontFamily.Pretendard.bold.font(size: 30)
  /// ExtraBold - size : 30 weight : 800
  static let thtH1Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 30)

  /// Regular - size : 26 weight : 400
  static let thtH2R = DSKitFontFamily.Pretendard.regular.font(size: 26)
  /// Meduim - size : 26 weight : 500
  static let thtH2M = DSKitFontFamily.Pretendard.medium.font(size: 26)
  /// SemiBold - size : 26 weight : 600
  static let thtH2Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 26)
  /// Bold - size : 26 weight: 700
  static let thtH2B = DSKitFontFamily.Pretendard.bold.font(size: 26)
  /// ExtraBold - size : 26 weight : 800
  static let thtH2Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 26)

  /// Regular - size : 24 weight : 400
  static let thtH3R  = DSKitFontFamily.Pretendard.regular.font(size: 24)
  /// Meduim - size : 24 weight : 500
  static let thtH3M  = DSKitFontFamily.Pretendard.medium.font(size: 24)
  /// SemiBold - size : 24 weight : 600
  static let thtH3Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 24)
  /// Bold - size : 24 weight : 700
  static let thtH3B  = DSKitFontFamily.Pretendard.bold.font(size: 24)
  /// ExtraBold - size : 24 weight : 800
  static let thtH3Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 24)

  /// Regular - size : 19 weight : 400
  static let thtH4R  = DSKitFontFamily.Pretendard.regular.font(size: 19)
  /// Meduim - size : 19 weight : 500
  static let thtH4M  = DSKitFontFamily.Pretendard.medium.font(size: 19)
  /// SemiBold - size : 19 weight : 600
  static let thtH4Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 19)
  /// Bold - size : 19 weight : 700
  static let thtH4B  = DSKitFontFamily.Pretendard.bold.font(size: 19)
  /// ExtraBold - size : 19 weight : 800
  static let thtH4Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 19)

  /// Regular - size : 17 weight : 400
  static let thtH5R  = DSKitFontFamily.Pretendard.regular.font(size: 17)
  /// Meduim - size : 17 weight : 500
  static let thtH5M  = DSKitFontFamily.Pretendard.medium.font(size: 17)
  /// SemiBold - size : 17 weight : 600
  static let thtH5Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 17)
  /// Bold - size : 17 weight : 700
  static let thtH5B  = DSKitFontFamily.Pretendard.bold.font(size: 17)
  /// ExtraBold - size : 17 weight : 800
  static let thtH5Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 17)

  // MARK: - SubTitle
  /// Regular - size : 16 weight : 400
  static let thtSubTitle1R  = DSKitFontFamily.Pretendard.regular.font(size: 16)
  /// Meduim - size : 16 weight : 500
  static let thtSubTitle1M  = DSKitFontFamily.Pretendard.medium.font(size: 16)
  /// SemiBold - size : 16 weight : 600
  static let thtSubTitle1Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 16)
  /// Bold - size : 16 weight : 700
  static let thtSubTitle1B  = DSKitFontFamily.Pretendard.bold.font(size: 16)

  /// Regular - size : 15 weight : 400
  static let thtSubTitle2R  = DSKitFontFamily.Pretendard.regular.font(size: 15)
  /// Meduim - size : 15 weight : 500
  static let thtSubTitle2M  = DSKitFontFamily.Pretendard.medium.font(size: 15)
  /// SemiBold - size : 15 weight : 600
  static let thtSubTitle2Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 15)
  /// Bold - size : 15 weight : 700
  static let thtSubTitle2B  = DSKitFontFamily.Pretendard.bold.font(size: 15)

  // MARK: - P
  /// Regular - size : 14 weight : 400
  static let thtP1R  = DSKitFontFamily.Pretendard.regular.font(size: 14)
  /// Meduim - size : 14 weight : 500
  static let thtP1M  = DSKitFontFamily.Pretendard.medium.font(size: 14)
  /// SemiBold - size : 14 weight : 600
  static let thtP1Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 14)
  /// Bold - size : 14 weight : 700
  static let thtP1B  = DSKitFontFamily.Pretendard.bold.font(size: 14)

  /// Regular - size : 12 weight : 400
  static let thtP2R  = DSKitFontFamily.Pretendard.regular.font(size: 12)
  /// Meduim - size : 12 weight : 500
  static let thtP2M  = DSKitFontFamily.Pretendard.medium.font(size: 12)
  /// SemiBold - size : 12 weight : 600
  static let thtP2Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 12)
  /// Bold - size : 12 weight : 700
  static let thtP2B  = DSKitFontFamily.Pretendard.bold.font(size: 12)

  // MARK: - Caption
  /// Regular - size : 11 weight : 400
  static let thtCaption1R  = DSKitFontFamily.Pretendard.regular.font(size: 11)
  /// Meduim - size : 11 weight : 500
  static let thtCaption1M  = DSKitFontFamily.Pretendard.medium.font(size: 11)
  /// SemiBold - size : 11 weight : 600
  static let thtCaption1Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 11)
  /// Bold - size : 11 weight : 700
  static let thtCaption1B  = DSKitFontFamily.Pretendard.bold.font(size: 11)

  /// Regular - size : 10 weight : 400
  static let thtCaption2R  = DSKitFontFamily.Pretendard.regular.font(size: 10)
  /// Meduim - size : 10 weight : 500
  static let thtCaption2M  = DSKitFontFamily.Pretendard.medium.font(size: 10)
  /// SemiBold - size : 10 weight : 600
  static let thtCaption2Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 10)
  /// Bold - size : 10 weight : 700
  static let thtCaption2B  = DSKitFontFamily.Pretendard.bold.font(size: 10)

  // MARK: - Exception
  static let thtEx1 = DSKitFontFamily.Pretendard.semiBold.font(size: 13)
  static let thtEx1M = DSKitFontFamily.Pretendard.medium.font(size: 13)

  static let thtEx4R  = DSKitFontFamily.Pretendard.regular.font(size: 22)
  static let thtEx4M  = DSKitFontFamily.Pretendard.medium.font(size: 22)
  static let thtEx4Sb = DSKitFontFamily.Pretendard.semiBold.font(size: 22)
  static let thtEx4B  = DSKitFontFamily.Pretendard.bold.font(size: 22)
  static let thtEx4Eb = DSKitFontFamily.Pretendard.extraBold.font(size: 22)
}
