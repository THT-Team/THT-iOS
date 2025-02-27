//
//  TransferErrorCard.swift
//  DSKit
//
//  Created by Kanghos on 2/27/25.
//

import UIKit

public class TransferErrorCard: TFBaseView {

  private let descriptionView = TFMultiLineDescriptionView(
    description:
      "알 수 없는 오류 발생. 다시 시도해 주세요. 문제가 지속될 시\nteamtht23@gmail.com로 연락 부탁드립니다.")

  public override func makeUI() {
    let imageView = UIImageView(image: DSKitAsset.Bx.transferError.image)

    let titleLabel = UILabel()
    titleLabel.textColor = DSKitAsset.Color.neutral50.color
    titleLabel.text = "오류 발생"
    titleLabel.textAlignment = .center
    titleLabel.font = .thtH2B

    addSubviews(imageView, titleLabel, descriptionView)

    imageView.snp.makeConstraints {
      $0.width.equalTo(264.adjusted)
      $0.height.equalTo(212.adjustedH)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(227.adjustedH)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(24.adjustedH)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(34.adjustedH)
    }

    descriptionView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.greaterThanOrEqualTo(30.adjustedH)
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-54.adjustedH)
    }
  }
}

public final class TransferErrorCardVC: TFBaseViewController {
  public override func loadView() {
    self.view = TransferErrorCard()
  }
}
