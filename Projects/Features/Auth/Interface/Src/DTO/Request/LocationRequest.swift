//
//  LocationRequest.swift
//  AuthInterface
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

// MARK: - LocationRequest
public struct LocationReq: Codable {
  public let address: String
  public let regionCode: Int
  public let lat, lon: Double

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
