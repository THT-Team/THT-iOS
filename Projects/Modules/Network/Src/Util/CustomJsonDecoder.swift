//
//  CustomJsonDecoder.swift
//  Networks
//
//  Created by Kanghos on 2/20/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

extension ParseStrategy where Self == Date.ISO8601FormatStyle {
  static var iso8601OptionalFractionalSeconds: Self { .init(includingFractionalSeconds: true)
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static let iso8601withOptionalFractionalSeconds = custom {
    var rawString = try $0.singleValueContainer().decode(String.self)
    if !rawString.hasSuffix("Z") {
      rawString.append(contentsOf: "Z")
    }
    rawString = rawString.replacingOccurrences(of: " ", with: "T")

    do {
      return try .init(rawString, strategy: .iso8601OptionalFractionalSeconds)
    } catch {
      return try .init(rawString, strategy: .iso8601)
    }
  }
}

extension JSONDecoder {
  public static let customDeocder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withOptionalFractionalSeconds
    return decoder
  }()
}
