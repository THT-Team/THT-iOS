//
//  LikeProfileReusableView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import Domain

public class TFBaseCollectionReusableView: UICollectionReusableView {

  override public init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }

  public enum Metric {
    static let horizontalPadding: CGFloat = 16
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func makeUI() {
    fatalError()
  }
}

public final class ProfileInfoReusableView: TFBaseCollectionReusableView {
  var disposeBag = DisposeBag()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtH1B
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()

  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtP2Sb
    label.textColor = DSKitAsset.Color.neutral50.color.withAlphaComponent(0.6)
    return label
  }()

  private lazy var pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.pinSmall.image
    return imageView
  }()
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtP2R
    return label
  }()

  public lazy var reportButton = UIButton.createReportButton()

  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral600.color
    self.addSubviews([
      titleLabel,
      pinImageView, addressLabel,
      reportButton,
      subTitleLabel
    ])

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.horizontalPadding)
      $0.leading.equalToSuperview()
    }

    pinImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.equalTo(titleLabel).offset(-1)
    }
    addressLabel.snp.makeConstraints {
      $0.centerY.equalTo(pinImageView)
      $0.leading.equalTo(pinImageView.snp.trailing)
    }

    subTitleLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(pinImageView.snp.bottom).offset(14)
    }

    reportButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().inset(Metric.horizontalPadding)
      $0.size.equalTo(24)
    }
  }

  public func bind(title: String?, subtitle: String?, header: String) {
    self.titleLabel.text = title
    self.addressLabel.text = subtitle
    self.subTitleLabel.text = header
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    addressLabel.text = nil

    disposeBag = DisposeBag()
  }
}
