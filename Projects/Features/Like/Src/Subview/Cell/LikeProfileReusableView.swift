//
//  LikeProfileReusableView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import LikeInterface
import Core
import DSKit

import SnapKit
import RxSwift

final class LikeProfileInfoReusableView: UICollectionReusableView {

  var disposeBag = DisposeBag()

  private lazy var sections: [ProfileInfoSection] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tagCollectionView.sections = self.sections
      }
    }
  }

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtH1B
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
  private lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([pinImageView, addressLabel])
    stackView.axis = .horizontal
    return stackView
  }()
  private lazy var vStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([titleLabel, hStackView])
    stackView.axis = .vertical
    stackView.alignment = .leading
    return stackView
  }()

  lazy var tagCollectionView = TagCollectionView()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubviews([vStackView, tagCollectionView])

    vStackView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(15)
    }
    tagCollectionView.snp.makeConstraints {
      $0.top.equalTo(vStackView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  func bind(viewModel: LikeUserInfo) {
    self.titleLabel.text = viewModel.description
    self.addressLabel.text = viewModel.address
    self.sections = [
      ProfileInfoSection(
        header: "이상형",
        items: viewModel.idealTypeList.map { $0.toEmoji() }
      ),
      ProfileInfoSection(
        header: "흥미",
        items: viewModel.idealTypeList.map { $0.toEmoji() }
      ),
      ProfileInfoSection(
        header: "자기소개",
        introduce: viewModel.introduction
      )
    ]
  }
}
