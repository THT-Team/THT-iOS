//
//  NicknameView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import UIKit

import Core
import DSKit

import SnapKit
import Then

final class NicknameView: TFBaseView {

  lazy var nicknameInputView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "닉네임을 알려주세요"
    $0.font = .thtH1B
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  lazy var nicknameTextField: UITextField = UITextField().then {
    $0.placeholder = "닉네임"
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtH2B
    $0.keyboardType = .numberPad
  }

  lazy var clearBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.closeCircle.image, for: .normal)
    $0.setTitle(nil, for: .normal)
    $0.backgroundColor = .clear
  }

  lazy var divider: UIView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral300.color
  }

  lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descLabel: UILabel = UILabel().then {
    $0.text = "폴링에서 활동할 자유로운 호칭을 설정해주세요"
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  lazy var nextBtn: UIButton = UIButton().then {
    $0.setTitle("화살표", for: .normal)
    $0.setTitleColor(DSKitAsset.Color.neutral600.color, for: .normal)
    $0.titleLabel?.font = .thtH5B
    $0.backgroundColor = DSKitAsset.Color.primary500.color
    $0.layer.cornerRadius = 16
  }

  override func makeUI() {
    addSubview(nicknameInputView)

    nicknameInputView.addSubviews(titleLabel, nicknameTextField, clearBtn, divider, infoImageView, descLabel, nextBtn)

    nicknameInputView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(frame.height * 0.09)
      $0.leading.equalToSuperview().inset(38)
    }

    nicknameTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview().inset(38)
      $0.trailing.equalTo(clearBtn.snp.trailing)
    }

    clearBtn.snp.makeConstraints {
      $0.centerY.equalTo(nicknameTextField.snp.centerY)
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview().inset(38)
    }

    divider.snp.makeConstraints {
      $0.leading.equalTo(nicknameTextField.snp.leading)
      $0.trailing.equalTo(clearBtn.snp.trailing)
      $0.height.equalTo(2)
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(2)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(nicknameTextField.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(divider.snp.bottom).offset(16)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(divider.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(38)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.bottom.equalToSuperview().offset(14)
      $0.height.equalTo(54)
    }
  }
}
