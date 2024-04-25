//
//  Agrement.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public struct Agreement: Codable {
  let serviceUseAgree : Bool
  let personalPrivacyInfoAgree : Bool
  let locationServiceAgree : Bool
  let marketingAgree : Bool

  public init(serviceUseAgree: Bool, personalPrivacyInfoAgree: Bool, locationServiceAgree: Bool, marketingAgree: Bool) {
    self.serviceUseAgree = serviceUseAgree
    self.personalPrivacyInfoAgree = personalPrivacyInfoAgree
    self.locationServiceAgree = locationServiceAgree
    self.marketingAgree = marketingAgree
  }
}
