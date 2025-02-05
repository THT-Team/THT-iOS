//
//  GenderPickerView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import DSKit
import RxSwift
import SignUpInterface
import Domain

class GenderPickerView: TFBaseView {

  lazy var genderPickerView = ButtonPickerView(
    title: "성별, 생일을 입력해주세요.", targetString: "성별, 생일",
    option1: "여자", option2: "남자"
  )
  
  lazy var birthdayLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.font = .thtH2B
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descriptionView = TFOneLineDescriptionView(description: "입력하신 나이와 성별은 추후 변경할 수 없습니다.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    addSubviews(
      genderPickerView,
      birthdayLabel,
      descriptionView,
      nextBtn
    )

    genderPickerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjustedH)
    }

    birthdayLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(genderPickerView)
      $0.top.equalTo(genderPickerView.snp.bottom).offset(64.adjustedH)
      $0.height.lessThanOrEqualTo(50)
    }

    descriptionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(genderPickerView)
      $0.top.equalTo(birthdayLabel.snp.bottom).offset(16.adjustedH)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}

extension Reactive where Base: GenderPickerView {
  var selectedGender: Binder<Gender> {
    return Binder(base.self) { view, gender in
      view.genderPickerView.handleSelectedState(gender == .female ? .left : .right)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct GenderPickerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return GenderPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
