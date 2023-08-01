//
//  CertificateResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct CertificateResponse: Codable {
    let phoneNumber: String
    let authNumber: Int

  enum CodingKeys: String, CodingKey {
      case phoneNumber, authNumber
  }
}
