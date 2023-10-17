//
//  ServiceAgreementRowView.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import Then
import SnapKit

enum AgreementType {
	case termsOfServie
	case privacyPolicy
	case locationService
	case marketingService
	
	var labelTitle: String {
		switch self {
		case .termsOfServie:
			return "(필수) 이용 약관 동의"
		case .privacyPolicy:
			return "(필수) 개인 정보 수집 및 이용 동의"
		case .locationService:
			return "(필수) 위치 기반 서비스 약관 동의"
		case .marketingService:
			return "(선택) 마케팅 정보 수신 동의"
		}
	}
	
	var isConnectWebView: Bool {
		switch self {
		case .locationService, .privacyPolicy, .termsOfServie:
			return true
		case .marketingService:
			return false
		}
	}
	
	var isAddDiscription: Bool {
		switch self {
		case .locationService, .privacyPolicy, .termsOfServie:
			return false
		case .marketingService:
			return true
		}
	}
}

final class ServiceAgreementRowView: TFBaseView {
	
	private let serviceType: AgreementType
	
	lazy var agreeBtn: UIButton = UIButton().then {
		$0.setImage(FallingAsset.Image.check.image, for: .normal)
		$0.setTitle(serviceType.labelTitle, for: .normal)
		$0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
		$0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
		$0.titleLabel?.font = .thtSubTitle1R
		$0.setTitleColor(FallingAsset.Color.neutral50.color, for: .normal)
	}
		
	lazy var goWebviewBtn: UIButton = UIButton().then {
		$0.setImage(FallingAsset.Image.chevronRight.image.withRenderingMode(.alwaysTemplate), for: .normal)
		$0.imageView?.contentMode = .scaleAspectFit
		$0.tintColor = FallingAsset.Color.neutral400.color
	}
	
	private lazy var discriptionText: UILabel = UILabel().then {
		$0.text = "폴링에서 제공하는 이벤트/혜택 등 다양한 정보를\nPush 알림으로 받아보실 수 있습니다."
		$0.font = .thtCaption1M
		$0.textColor = FallingAsset.Color.neutral400.color
		$0.numberOfLines = 2
	}
	
	init(serviceType: AgreementType) {
		self.serviceType = serviceType
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func makeUI() {
		addSubviews([agreeBtn, goWebviewBtn, discriptionText])
		
		agreeBtn.snp.makeConstraints {
			$0.leading.top.bottom.equalToSuperview()
		}
		
		if serviceType.isConnectWebView {
			goWebviewBtn.snp.makeConstraints {
				$0.top.bottom.trailing.equalToSuperview()
				$0.width.height.equalTo(24)
			}
		} else {
			goWebviewBtn.isHidden = true
		}
		
		if serviceType.isAddDiscription {
			discriptionText.snp.makeConstraints {
				$0.top.equalTo(agreeBtn.snp.bottom).offset(2)
				$0.leading.equalToSuperview().offset(30)
			}
		} else {
			discriptionText.isHidden = true
		}
	}
	
}
