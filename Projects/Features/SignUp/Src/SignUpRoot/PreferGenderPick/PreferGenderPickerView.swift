//
//  PreferGenderPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//
import UIKit

import DSKit
import RxSwift
import SignUpInterface
import Domain

final class PreferGenderPickerView: TFBaseView {

  lazy var genderPickerView = TFButtonPickerView(
    title: "선호 성별을 알려주세요.", targetString: "선호 성별",
    options: GenderMapper.options
  )

  lazy var descriptionView = TFOneLineDescriptionView(description: "마이페이지에서 변경가능합니다.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      genderPickerView,
      descriptionView,
      nextBtn
    )

    genderPickerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    descriptionView.snp.makeConstraints {
      $0.top.equalTo(genderPickerView.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(genderPickerView)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}

extension Reactive where Base: PreferGenderPickerView {
  var selectedGender: Binder<Gender> {
    Binder(base.self) { view, gender in
      view.genderPickerView.handleSelectedState(GenderMapper.toOption(gender))
    }
  }
}

struct GenderMapper {
  static func toOption(_ gender: Gender) -> TFButtonPickerView.Option {
    switch gender {
    case .female:
      return .init(key: 0, value: "여자")
    case .male:
      return .init(key: 1, value: "남자")
    case .bisexual:
      return .init(key: 2, value: "모두")
    }
  }

  static func toGender(_ option: TFButtonPickerView.Option) -> Gender {
    switch option.key {
    case 0: return .female
    case 1: return .male
    default: return .bisexual
    }
  }

  static var options: [String] {
    return ["여자", "남자", "모두"]
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PreferGenderPickerViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return PreferGenderPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
