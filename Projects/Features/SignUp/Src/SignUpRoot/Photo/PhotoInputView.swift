//
//  PhotoInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import DSKit


final class PhotoInputView: TFBaseView {
  
  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }
  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "사진을 추가해주세요"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH1B
    $0.asColor(targetString: "사진", color: DSKitAsset.Color.neutral50.color)
  }

  lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .photoPickLayout())

  lazy var contentVStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
  }

  lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descLabel: UILabel = UILabel().then {
    $0.text = "얼굴이 잘 나온 사진 2장을 필수로 넣어주세요."
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(container)

    photoCollectionView.backgroundColor = .clear

    container.addSubviews(
      titleLabel,
      contentVStackView,
      infoImageView, descLabel,
      nextBtn
    )

    contentVStackView.addArrangedSubview(photoCollectionView)
    
    container.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(76)
      $0.leading.trailing.equalToSuperview().inset(30)
    }

    contentVStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(titleLabel)
    }

    photoCollectionView.snp.makeConstraints {
      $0.height.equalTo(contentVStackView.snp.width)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(contentVStackView.snp.bottom).offset(10)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(infoImageView)
      $0.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(30)
      $0.trailing.equalTo(descLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(88)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PhotoInputViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return PhotoInputView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
