//
//  MarketingInfoAgreement.swift
//  SignUp
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

public struct MarketingInfoAgreement: Codable {
  public var isAgree: Bool
  public var timeStamp: String

  public init(isAgree: Bool, timeStamp: String) {
    self.isAgree = isAgree
    self.timeStamp = timeStamp
  }
}
