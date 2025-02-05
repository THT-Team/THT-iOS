//
//  KakaoCoordinate2dRes.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation
import SignUpInterface
import AuthInterface
import Domain

struct KakaoCoordinateRes: Codable {
  let documents: [Document]

  struct Document: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let regionType: String
    let code: String
    let x, y: Double

    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case regionType = "region_type"
      case code
      case x, y
    }

    enum RegionType: String, Codable {
      case admin = "H"
      case law = "B"

      private enum CodingKeys: String, CodingKey {
        case admin = "H"
        case law = "B"
      }
    }
  }
}

extension KakaoCoordinateRes {
  func toDomain() -> LocationReq? {
    let lawAddress = documents.first { docmuent in
      docmuent.regionType == "B"
    }

    guard let document = lawAddress else { return nil }


    var cityName = document.region1depthName
    if cityName.hasSuffix("특별시") {
      cityName = cityName.replacingOccurrences(of: "특별시", with: "")
    } else if cityName.hasSuffix("광역시") {
      cityName = cityName.replacingOccurrences(of: "광역시", with: "")
    }

    var dongName = document.region3depthName
    while !dongName.isEmpty {
      if dongName.hasSuffix("동") {
        break
      }
      dongName.removeLast()
    }

    let addressName = [cityName, document.region2depthName, dongName].joined(separator: " ")

    return .init(address: addressName, regionCode: Int(document.code) ?? 0, lat: document.y, lon: document.x)
  }
}
