//
//  Configuration.swift
//  Core
//
//  Created by Kanghos on 12/2/24.
//

import Foundation

public struct Configuration {
  public static let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
  public static let kakaoNativeAppKey = Bundle.main.infoDictionary?["KakaoNativeAppKey"] as? String ?? ""
  public static let kakaoMapNativeAppKey = Bundle.main.infoDictionary?["KakaoMapNativeKey"] as? String ?? ""
}
