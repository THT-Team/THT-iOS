//
//  LocationInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import UIKit

import DSKit

final class LocationInputView: TFBaseView {
  lazy var containerView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "현재 위치를 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.asColor(targetString: "현재 위치를", color: DSKitAsset.Color.neutral50.color)
    $0.font = .thtH1B
  }

  lazy var locationField = LocationInputField()

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(containerView)
    containerView.addSubviews(
      titleLabel,
      locationField,
      nextBtn
    )
    
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(76)
      $0.leading.equalToSuperview().inset(38)
    }

    locationField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(38)
    }

    // webview -> 주소, 법정동코드 수집 -> KAKAO API 좌표 추가 수집
    // 매니저에서 -> 주소(로드 정확하게), 좌표 -> 벙정동코드 추가 수집
    // 파라미터 저장, 이미지 저장
    // 파라미터로 값 초기화

    // 

    nextBtn.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(38)
      $0.height.equalTo(54)
      $0.width.equalTo(88)
      $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-16)
    }
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LocationInputViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let component = LocationInputView()
      component.locationField.bind("서울시 성북구 성북동")
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
