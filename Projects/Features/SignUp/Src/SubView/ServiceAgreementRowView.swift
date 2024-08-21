//
//  ServiceAgreementRowView.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import DSKit
import SignUpInterface

final class ServiceAgreementRowView: UITableViewCell {

  private var disposeBag = DisposeBag()
  private var model: AgreementElement?

  var agreeBtnOnCliek: (() -> Void)?
  var goWebviewBtnOnClick: (() -> Void)?

  lazy var checkmark = UIImageView().then {
    $0.image = DSKitAsset.Image.Component.check.image
  }


  lazy var titleLabel = UILabel().then {
    $0.font = .thtSubTitle1R
    $0.numberOfLines = 2
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.lineBreakStrategy = .hangulWordPriority
  }

  lazy var goWebviewBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Component.chevronRight.image.withRenderingMode(.alwaysTemplate), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.tintColor = DSKitAsset.Color.neutral400.color
    $0.addAction(UIAction { [weak self] _ in
      self?.goWebviewBtnOnClick?()
    }, for: .touchUpInside)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var descriptionText: UILabel = UILabel().then {
    $0.font = .thtP2M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.numberOfLines = 2
  }

  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
    super.prepareForReuse()
    agreeBtnOnCliek = nil
    goWebviewBtnOnClick = nil
  }

  private lazy var containerView = UIView()

  func makeUI() {
    contentView.addSubview(goWebviewBtn)
    contentView.addSubview(checkmark)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionText)
    contentView.backgroundColor = DSKitAsset.Color.neutral700.color
    goWebviewBtn.snp.makeConstraints {
      $0.size.equalTo(30)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkmark.snp.trailing).offset(10)
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalTo(goWebviewBtn.snp.leading)
    }

    checkmark.snp.makeConstraints {
      $0.size.equalTo(20)
      $0.top.equalTo(titleLabel)
      $0.leading.equalToSuperview()
    }

    descriptionText.setContentHuggingPriority(.defaultHigh, for: .vertical)
    descriptionText.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalTo(titleLabel)
      $0.height.lessThanOrEqualTo(30)
      $0.bottom.equalToSuperview().offset(-5)
    }
  }

  func bind(_ viewModel: ServiceAgreementRowViewModel) {
    self.model = viewModel.model
    self.titleLabel.text = viewModel.model.subject
    self.descriptionText.text = viewModel.model.description
    self.checkmark.image = viewModel.image.image
    goWebviewBtn.isHidden = (viewModel.model.detailLink ?? "").isEmpty
  }
}

extension ServiceAgreementRowViewModel {
  var image: DSKitImages {
    isSelected
    ? DSKitAsset.Image.Component.checkSelect
    : DSKitAsset.Image.Component.check
  }
}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct ServiceAgreementRowViewPreview: PreviewProvider {
//
//  static var previews: some View {
//    UIViewPreview {
//      let view = ServiceAgreementRowView()
//      return ServiceAgreementRowView()
//    }
//    .frame(width: 375, height: 100)
//    .previewLayout(.sizeThatFits)
//  }
//}
//#endif
