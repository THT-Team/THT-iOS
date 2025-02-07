//
//  AlcoholTobaccoInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit
import SignUpInterface
import DSKit
import RxSwift
import Domain

class AlcoholTobaccoPickerView: TFBaseView {
  lazy var titleLabel = UILabel.setTargetBold(text: "추가정보를 알려주세요.", target: "추가정보", font: .thtH1B, targetFont: .thtH1B)

  lazy var tobaccoPickerView = TFButtonPickerView(
    title: "흡연 스타일을 선택해주세요.", targetString: "흡연",
    options: [
      "안함",
      "가끔",
      "자주"
    ],
    titleType: .sub
  )

  lazy var alcoholPickerView = TFButtonPickerView(
    title: "주량을 선택해주세요.", targetString: "주량",
    options: [
      "안함",
      "가끔",
      "자주"
    ],
    titleType: .sub
  )

  lazy var descriptionView = TFOneLineDescriptionView(description: "마이페이지에서 변경가능합니다.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      tobaccoPickerView,
      alcoholPickerView,
      descriptionView,
      nextBtn
    )
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    tobaccoPickerView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(38.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    alcoholPickerView.snp.makeConstraints {
      $0.top.equalTo(tobaccoPickerView.snp.bottom).offset(64.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    descriptionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(alcoholPickerView.snp.bottom).offset(16.adjustedH)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}

extension Reactive where Base == AlcoholTobaccoPickerView {
  var selectedFrequecy: Binder<AlcoholTobaccoPickerViewModel.FrequencyType> {
    Binder(base.self) { view, frequencyType in
      switch frequencyType {
      case let .drinking(frequency):
        view.alcoholPickerView.handleSelectedState(FrequencyMapper.toOption(frequency))
      case let .smoking(frequency):
        view.tobaccoPickerView.handleSelectedState(FrequencyMapper.toOption(frequency))
      }
    }
  }
}

struct FrequencyMapper {
  static func toOption(_ frequency: Frequency) -> TFButtonPickerView.Option {
    switch frequency {
    case .none:
      return .init(key: 0, value: "안함")
    case .sometimes:
      return .init(key: 1, value: "가끔")
    case .frequently:
      return .init(key: 2, value: "자주")
    }
  }

  static func toFrequency(_ option: TFButtonPickerView.Option) -> Frequency {
    switch option.key {
    case 0: return .none
    case 1: return .sometimes
    default: return .frequently
    }
  }

  static var options: [String] {
    return ["안함", "가끔", "자주"]
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct AlcoholTobaccoPickerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return AlcoholTobaccoPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
