//
//  LocaleReq.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

// MARK: - LocationRequest
public struct LocationReq: Codable {
  let address: String
  let regionCode: Int
  let lat, lon: Double

  public init(
    address: String,
    regionCode: Int,
    lat: Double, lon: Double
  ) {
    self.address = address
    self.regionCode = regionCode
    self.lat = lat
    self.lon = lon
  }
}
