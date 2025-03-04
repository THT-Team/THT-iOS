//
//  KakaoSearchRes.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation

import Domain

struct KakaoSearchRes: Codable {
  let documents: [Document]

  struct Document: Codable {
    let address: Address?
    let roadAddress: RoadAddress?
    let x, y: String

    private enum CodingKeys: String, CodingKey {
      case address, x, y
      case roadAddress = "road_address"
    }
  }

  struct Address: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let lawCode: String
    let x, y: String

    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case lawCode = "b_code"
      case x, y
    }
  }

  struct RoadAddress: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let x,y: String

    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case x, y
    }
  }
}

extension KakaoSearchRes {
  func toDomain() -> LocationReq? {
    guard let document = documents.first,
          let address = document.address,
          let longitude = Double(document.x),
          let latitude = Double(document.y) else {
      return nil
    }
    
    let addressName = [address.region1depthName, address.region2depthName, address.region3depthName].joined(separator: " ")

    let code = Int(address.lawCode) ?? 0
    return .init(address: addressName, regionCode: code, lat: latitude, lon: longitude)
  }
}
