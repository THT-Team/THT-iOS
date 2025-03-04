//
//  MenuFactory.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/24/24.
//

import Foundation
import Domain

public final class MenuFactory {
  static func makeStaticSettingMenus(user: User) -> [SectionModel<MySetting.MenuItem>] {
    return [
      SectionModel(
        type: .account,
        items: [
          .item(MySetting.Item(title: "연동된 SNS", content: "Google")),
        ]),
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
          .linkItem(MySetting.LinkItem(title: "자주 묻는 질문", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .item(MySetting.Item(title: "문의 및 피드백 보내기"))]),
      SectionModel(
        type: .law,
        items: [
          .linkItem(MySetting.LinkItem(title: "서비스 이용약관", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "개인정보 처리방침", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "위치정보 이용약관", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "라이센스", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "사업자 정보", url: URL(string: "http://www.ftc.go.kr/bizCommPop.do?wrkr_no=6806400545")!))]),
      SectionModel(
        type: .accoutSetting,
        items: [.item(MySetting.Item(title: "계정 설정"))]),
    ]
  }
}
