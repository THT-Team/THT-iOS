//
//  DateFormatter+Util.swift
//  Core
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

extension DateFormatter {

  static var unixDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    formatter.locale = Locale(identifier: "ko-KR")

    return formatter
  }

  static var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    formatter.dateFormat = "hh:MM a"
//    formatter.locale = Locale(identifier: "ko-KR")
    return formatter
  }

  static var normalDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    formatter.locale = Locale(identifier: "ko-KR")

    return formatter
  }

  static var koreanDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
    formatter.locale = Locale(identifier: "ko-KR")

    return formatter
  }
  static var korean2DateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
//    formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
    formatter.locale = Locale(identifier: "ko-KR")

    return formatter
  }
}

public extension String {
  func toDate() -> Date {
    DateFormatter.normalDateFormatter.date(from: self) ?? Date()
  }
}

public extension Date {
  func toString(_ dateFormatter: DateFormatter) -> String {
    dateFormatter.string(from: self)
  }
  
  func toTimeString() -> String {
    DateFormatter.timeFormatter.string(from: self)
  }
  func toDateString() -> String {
    DateFormatter.unixDateFormatter.string(from: self)
  }
  func toYMDDotDateString() -> String {
    DateFormatter.normalDateFormatter.string(from: self)
  }

  func toKoreanDateString() -> String {
    DateFormatter.korean2DateFormatter.string(from: self)
  }

  // From GPT
  static func currentAdultDateOrNil() -> Date? {
         // 성년이 되는 나이
         let adulthoodAge = 21

         // 현재 달력
         var calendar = Calendar.current

         // 지역을 한국으로 설정 (옵션)
         calendar.locale = Locale(identifier: "ko_KR")

         // 날짜 구성 요소를 추출
         var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())

         // 성년 나이를 더함
         dateComponents.year = (dateComponents.year ?? 0) - adulthoodAge

         // 새로운 날짜를 생성하여 반환
         return calendar.date(from: dateComponents)
     }
}
