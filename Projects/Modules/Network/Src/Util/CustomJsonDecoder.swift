//
//  CustomJsonDecoder.swift
//  Networks
//
//  Created by Kanghos on 2/20/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

extension ParseStrategy where Self == Date.ISO8601FormatStyle {
  static var iso8601OptionalFractionalSeconds: Self {
      .init(
        includingFractionalSeconds: true,
        timeZone: TimeZone(identifier: "Asia/Seoul")!
      )
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

extension JSONDecoder.DateDecodingStrategy {
  static let kstWithFractionalSeconds = custom { decoder -> Date in
    let rawString = try decoder.singleValueContainer().decode(String.self)

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"

    guard let date = formatter.date(from: rawString) else {
      throw DecodingError.dataCorruptedError(
        in: try decoder.singleValueContainer(),
        debugDescription: "Unrecognized date format"
      )
    }
    return date
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static let flexibleKSTFractional = custom { decoder -> Date in
    let rawString = try decoder.singleValueContainer().decode(String.self)

    let formats = [
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS",
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS",
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
      "yyyy-MM-dd'T'HH:mm:ss.SSSS",
      "yyyy-MM-dd'T'HH:mm:ss.SSS",
      "yyyy-MM-dd'T'HH:mm:ss.SS",
      "yyyy-MM-dd'T'HH:mm:ss.S",
      "yyyy-MM-dd'T'HH:mm:ss"
    ]

    for format in formats {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
      formatter.dateFormat = format

      if let date = formatter.date(from: rawString) {
        return date
      }
    }

    throw DecodingError.dataCorruptedError(
      in: try decoder.singleValueContainer(),
      debugDescription: "Could not parse date: \(rawString)"
    )
  }
}


extension JSONDecoder {
    public static let customDeocder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleKSTFractional
        return decoder
    }()
}

extension JSONDecoder {
    public static let fractionalWithoutTimezone: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .kstWithFractionalSeconds
        return decoder
    }()
}
