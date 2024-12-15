//
//  Configuration.swift
//  Core
//
//  Created by Kanghos on 12/2/24.
//

import Foundation

public struct Configuration {
  public static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
  public static let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
  public static let kakaoMapNativeAppKey = Bundle.main.infoDictionary?["KAKAO_MAP_NATIVE_KEY"] as? String ?? ""
}
