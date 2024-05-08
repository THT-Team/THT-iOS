//
//  DocumentFromAddressRes.swift
//  SignUp
//
//  Created by Kanghos on 5/5/24.
//

import Foundation

// MARK: - AddressResponse
struct AddressRes: Codable {
  let documents: [Document]

  // MARK: - Document
  struct Document: Codable {
    let address: Address
    let addressName: String
    let roadAddress: Address
    let lon: String
    let lat: String

    enum CodingKeys: String, CodingKey {
      case address
      case addressName = "address_name"
      case roadAddress = "road_address"
      case lon = "x"
      case lat = "y"
    }
  }

  // MARK: - Address
  struct Address: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String

    enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1DepthName = "region_1depth_name"
      case region2DepthName = "region_2depth_name"
      case region3DepthName = "region_3depth_name"
    }
  }
}

extension Addressres {
  func toDomain -> LocationReq {
    
  }
}
