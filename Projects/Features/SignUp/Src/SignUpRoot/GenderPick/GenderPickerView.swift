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

class GenderPickerView: TFBaseView {
  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var genderPickerView = ButtonPickerView(
    title: "성별, 생일을 입력해주세요.", targetString: "성별, 생일",
    option1: "여자", option2: "남자"
  )
  
  lazy var birthdayLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.font = .thtH2B
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

  lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descLabel: UILabel = UILabel().then {
    $0.text = "입력하신 나이와 성별은 추후 변경할 수 없습니다."
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(container)

    container.addSubviews(
      genderPickerView,
      birthdayLabel,
      infoImageView, descLabel,
      nextBtn
    )
    container.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }

    genderPickerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(76)
      $0.leading.trailing.equalToSuperview()
    }

    birthdayLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.top.equalTo(genderPickerView.snp.bottom).offset(10)
      $0.height.equalTo(50)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(birthdayLabel.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(birthdayLabel.snp.bottom).offset(16)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(birthdayLabel.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(38)
    }
    nextBtn.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(30)
      $0.trailing.equalTo(birthdayLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(88)
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
