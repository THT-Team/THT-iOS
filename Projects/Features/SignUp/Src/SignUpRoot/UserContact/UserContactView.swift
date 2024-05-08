//
//  UserContactView.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/2/24.
//

import UIKit

import DSKit

final class UserContactView: TFBaseView {
  lazy var containerView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }
  
  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "혹시 폴링에서\n아는 사람을 만날까봐\n걱정되시나요?"
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.font = .thtH2B
    $0.numberOfLines = 0
  }
  
  lazy var descLabel = UILabel().then {
    $0.text = "폴링에서 아는 사람을 마주치고 싶지 않다면\n해당 기능을 켜주세요."
    $0.font = .thtSubTitle1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }
  
  lazy var blockBtn = CTAButton(btnTitle: "아는 사람 만나지 않기", initialStatus: true)
  lazy var layterBtn = CTAButton(btnTitle: "나중에 하기", initialStatus: false)
  
  override func makeUI() {
    addSubview(containerView)
    containerView.addSubviews(
      titleLabel,
      descLabel,
      blockBtn,
      layterBtn
    )
    
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(76)
      $0.leading.equalToSuperview().inset(38)
    }
    
    descLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(38)
    }
    
    blockBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(layterBtn.snp.top).offset(-16)
      $0.height.equalTo(54)
    }
    
    layterBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(54)
    }
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct InputViewPreview: PreviewProvider {
  
  static var previews: some View {
    UIViewPreview {
      let component = UserContactView()
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif

