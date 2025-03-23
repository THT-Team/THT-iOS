//
//  PopUpTextBtnCard.swift
//  MyPage
//
//  Created by Kanghos on 7/21/24.
//

import UIKit

import DSKit

public class TFPopUpTextBtnCard: TFBaseView {
  private let title: String
  private let descText: String
  private let btnTitle: String

  private lazy var container = UIView()
  public private(set) lazy var imageView = UIImageView().then {
    $0.image = DSKitAsset.Bx.eventWin.image
    $0.contentMode = .scaleAspectFit
  }

  public private(set) lazy var titleLabel = UILabel().then {
    $0.text = title
    $0.font = .thtH2B
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.textAlignment = .center
  }

  public private(set) lazy var descLabel = UILabel().then {
    $0.text = descText
    $0.font = .thtEx1M
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.textAlignment = .center
    $0.numberOfLines = 3
  }

  public private(set) lazy var backBtn = TFTextButton(title: btnTitle).then {
    $0.makeView(title: btnTitle, color: DSKitAsset.Color.primary500.color)
  }

  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral600.color
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 12

    addSubview(container)

    container.addSubviews(
      imageView,
      titleLabel,
      descLabel,
      backBtn
    )

    container.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(30)
      $0.leading.trailing.equalToSuperview().inset(24)
    }

    imageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(imageView.snp.bottom).offset(24)
    }

    descLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.height.greaterThanOrEqualTo(40).priority(.low)
    }

    backBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(descLabel.snp.bottom)
      $0.height.equalTo(48)
      $0.bottom.equalToSuperview()
    }
  }
  public init(title: String, description: String, btnTitle: String) {
    self.title = title
    self.btnTitle = btnTitle
    self.descText = description
    super.init(frame: .zero)
    makeUI()
  }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PopUpTextBtnViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return TFPopUpTextBtnCard(title: "문의하기 완료", description: "답변에는 하루 정도의 시간이 걸릴 수 있어요.\n답변이 안온다면, 스팸 메일함을 확인해주세요."
, btnTitle: "돌아가기")
    }
    .frame(width: 310, height: 450)
    .previewLayout(.sizeThatFits)
  }
}
#endif

