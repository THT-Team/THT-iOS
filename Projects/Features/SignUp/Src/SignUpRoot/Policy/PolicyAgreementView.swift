//
//  PolicyAgreementView.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import DSKit

final class PolicyAgreementView: TFBaseView {
  private lazy var logoView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Component.fallingLogo.image
  }

  lazy var selectAllBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Component.checkCir.image, for: .normal)
    $0.setTitle("전체 동의", for: .normal)
    $0.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    $0.titleLabel?.font = .thtH5B
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 7)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
  }

  private lazy var serviceRowsView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
  }
  
  lazy var termsOfServiceRow = ServiceAgreementRowView(serviceType: .termsOfServie)

  lazy var privacyPolicyRow = ServiceAgreementRowView(serviceType: .privacyPolicy)

  lazy var locationServiceRow = ServiceAgreementRowView(serviceType: .locationService)

  lazy var marketingServiceRow = ServiceAgreementRowView(serviceType: .marketingService)

  lazy var nextBtn = CTAButton(btnTitle: "시작하기", initialStatus: false)

  private lazy var discriptionText = UILabel().then {
    $0.text = """
 THT는 만 18세 이상부터 이용 가능하며, 타인의 계정으로 본 서비스를
 사용하는 경우 정보통신망 이용 촉진 및 정보보호 등에 관한 법률에 의거
 처벌을 받을 수 있습니다.
"""
    $0.font = .thtCaption1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.numberOfLines = 3
  }

  override func makeUI() {
    addSubviews([logoView, selectAllBtn, serviceRowsView, nextBtn, discriptionText])


    logoView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(30)
      $0.top.equalToSuperview().inset(26)
      $0.height.equalTo(22)
      $0.width.equalTo(77)
    }

    selectAllBtn.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(30)
      $0.top.equalTo(logoView.snp.bottom).offset(83)
    }

    serviceRowsView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(30)
      $0.trailing.equalToSuperview().inset(28)
      $0.top.equalTo(selectAllBtn.snp.bottom).offset(34)
    }

    serviceRowsView.addArrangedSubviews([termsOfServiceRow, privacyPolicyRow, locationServiceRow, marketingServiceRow])

    discriptionText.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(61)
      $0.leading.equalToSuperview().offset(38)
    }

    nextBtn.snp.makeConstraints {
      $0.bottom.equalTo(discriptionText.snp.top).offset(-6)
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.height.equalTo(54)
    }


  }

}
