//
//  SectionGenerator.swift
//  MyPageInterface
//
//  Created by Kanghos on 2/22/25.
//

import Foundation

public struct SectionGenerator {

  static func createMySettingSections(user: User, list: [SNSType]) -> [SectionModel<MySetting.MenuItem>] {
    [
      SectionModel(
        type: .banner,
        items: [.item(MySetting.Item(title: ""))]),
      SectionModel(
        type: .account,
        items: SectionGenerator.createAccountMenus(list: list, user: user)),
      SectionModel(
        type: .activity,
        items: [.item(MySetting.Item(title: "저장된 연락처 차단하기"))]),
      SectionModel(
        type: .location,
        items: [.item(MySetting.Item(title: "위치 설정", content: user.address))]),
      SectionModel(
        type: .notification,
        items: [.item(MySetting.Item(title: "알림 설정"))]),
      SectionModel(
        type: .support,
        items: [
          .linkItem(MySetting.LinkItem(title: "자주 묻는 질문", url: URL(string: "https://janechoi.notion.site/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .item(MySetting.Item(title: "문의 및 피드백 보내기"))]),
      SectionModel(
        type: .law,
        items: [
          .linkItem(MySetting.LinkItem(title: "서비스 이용약관", url: URL(string: "https://janechoi.notion.site/526c51e9cb584f29a7c16251914bb3cb?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "개인정보 처리방침", url: URL(string: "https://janechoi.notion.site/5923a3c20259459bbacaff41290fc615?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "위치정보 이용약관", url: URL(string: "https://janechoi.notion.site/b45cf5f24d39494daf0a03b907a2ab7d?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "라이센스", url: URL(string: "https://janechoi.notion.site/c424bc053e7a479daa595d8bd69b0d1f?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "사업자 정보", url: URL(string: "https://janechoi.notion.site/4f20dcc5c4084318910edfee3db5edb3?pvs=4")!))]),
      SectionModel(
        type: .accoutSetting,
        items: [.item(MySetting.Item(title: "계정 설정"))]),
    ]
  }

  private static func createAccountMenus(list: [SNSType], user: User) -> [MySetting.MenuItem] {
    guard !list.isEmpty else {
      return [
        .item(MySetting.Item(title: "핸드폰 번호", content: user.phoneNumber)),
        .item(MySetting.Item(title: "이메일", content: user.email)),
      ]
    }

    return list
      .filter { $0 != .normal }
      .compactMap { type -> MySetting.MenuItem? in
        switch type {
        case .kakao: return .item(MySetting.Item(title: "연동된 SNS", content: "카카오"))
        case .naver: return .item(MySetting.Item(title: "연동된 SNS", content: "네이버"))
        case .google: return .item(MySetting.Item(title: "연동된 SNS", content: "Google"))
        case .apple: return .item(MySetting.Item(title: "연동된 SNS", content: "Apple"))
        case .normal: return nil
        }
      }
  }
}
