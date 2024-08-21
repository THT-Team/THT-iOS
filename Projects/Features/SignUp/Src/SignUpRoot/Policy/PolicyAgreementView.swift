//
//  PolicyAgreementView.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import DSKit
import SignUpInterface

final class PolicyAgreementView: TFBaseView {
  private lazy var logoView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Component.fallingLogo.image
    $0.contentMode = .scaleAspectFit
  }

  private lazy var titleLabel = UILabel().then {
    $0.text = "폴링을 이용하려면 동의가 필요해요."
    $0.font = .thtH5Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  lazy var selectAllBtn = TFCheckButton(btnTitle: "전체 동의", initialStatus: false).then {

    $0.titleLabel?.font = .thtH5B
  }

  private(set) lazy var tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.register(cellType: ServiceAgreementRowView.self)
    $0.estimatedRowHeight = 110
    $0.rowHeight = UITableView.automaticDimension
    $0.allowsSelection = true
  }

  lazy var nextBtn = CTAButton(btnTitle: "시작하기", initialStatus: false)

  private lazy var discriptionText = UILabel.createMultiLineDescriptionLabel().then {
    $0.text = """
 Falling은 만 18세 이상부터 이용 가능하며, 타인의 계정으로 본 서비스를
 사용하는 경우 정보통신망 이용 촉진 및 정보보호 등에 관한 법률에 의거
 처벌을 받을 수 있습니다.
"""
    $0.lineBreakMode = .byWordWrapping
  }

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    addSubviews([logoView, titleLabel, selectAllBtn, tableView, nextBtn, discriptionText])
    
    logoView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(28.adjusted)
      $0.top.equalToSuperview().inset(134.adjustedH)
      $0.height.equalTo(22.adjustedH)
      $0.width.equalTo(77.adjusted)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(logoView.snp.bottom).offset(52.adjustedH)
      $0.leading.equalTo(logoView)
      $0.trailing.equalToSuperview().inset(28.adjustedH)
      $0.height.equalTo(40)
    }

    tableView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(28.adjustedH)
      $0.top.equalTo(titleLabel.snp.bottom).offset(34)
      $0.height.lessThanOrEqualTo(400).priority(.low)
      $0.bottom.equalTo(selectAllBtn.snp.top).offset(20)
    }

    selectAllBtn.snp.makeConstraints {
      $0.leading.trailing.equalTo(nextBtn)
      $0.bottom.equalTo(nextBtn.snp.top).offset(-16.adjustedH)
      $0.height.equalTo(54.adjustedH)
    }

    nextBtn.snp.makeConstraints {
      $0.bottom.equalTo(discriptionText.snp.top).offset(-6)
      $0.leading.trailing.equalToSuperview().inset(22.adjusted)
      $0.height.equalTo(54.adjustedH)
    }
    discriptionText.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-82.adjustedH)
      $0.leading.trailing.equalTo(nextBtn)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFCheckButtonwPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      PolicyAgreementView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
