//
//  ProfileInfoFooterReusableVIew.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import UIKit

import RxDataSources
import SnapKit
import RxSwift

final class ProfileInfoReusableView: UICollectionReusableView {
  var disposeBag = DisposeBag()
  private lazy var sections: [profileInfoSection] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  lazy var reportButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = FallingAsset.Image.reportFill.image.withTintColor(
      FallingAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = FallingAsset.Color.topicBackground.color
    button.configuration = config

    config.automaticallyUpdateForSelection = true
    return button
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtH1B
    return label
  }()

  private lazy var pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FallingAsset.Image.pinSmall.image
    return imageView
  }()
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = FallingAsset.Color.neutral50.color
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

  //  private lazy var tagView = TagCollectionView()
  private lazy var collectionView: UICollectionView = {
    let layout = LeftAlignCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.headerReferenceSize = CGSize(width: 200, height: 50)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.register(cellType: ProfileIntroduceCell.self)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = FallingAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubviews([vStackView, collectionView, reportButton])

    vStackView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(15)
    }
    reportButton.snp.makeConstraints {
      $0.trailing.top.equalToSuperview().inset(15)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(vStackView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  func configure(info: HeartUserResponse) {
    TFLogger.view.debug("\(info.username)")
    self.collectionView.dataSource = self

    self.titleLabel.text = info.description
    self.addressLabel.text = info.address
    self.sections = [
      profileInfoSection(header: "이상형", items: info.idealTypeList),
      profileInfoSection(header: "흥미", items: info.interestsList),
      profileInfoSection(header: "자기소개", introduce: info.introduction)
    ]
  }
}

extension ProfileInfoReusableView: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section < 2 else {
      return 1
    }
    return self.sections[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard indexPath.section < 2 else {
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
      cell.configure(self.sections[indexPath.section].introduce)
      return cell
    }
    let item = self.sections[indexPath.section].items[indexPath.item]
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
    cell.configure(TagItemViewModel(item))
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sections[indexPath.section].header
    return header
  }
}





