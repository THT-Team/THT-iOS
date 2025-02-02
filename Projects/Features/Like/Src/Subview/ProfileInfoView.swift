////
////  ProfileInfoView.swift
////  Like
////
////  Created by Kanghos on 1/11/25.
////
//
//import UIKit
//import DSKit
//import Domain
//
//public final class ProfileInfoView: TFBaseView {
//  enum Metric {
//    static let horizontalPadding: CGFloat = 16
//  }
//  private lazy var titleLabel: UILabel = {
//    let label = UILabel()
//    label.text = "최지인"
//    label.font = UIFont.thtH1B
//    return label
//  }()
//
//  private lazy var pinImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.image = DSKitAsset.Image.Icons.pinSmall.image
//    return imageView
//  }()
//  private lazy var addressLabel: UILabel = {
//    let label = UILabel()
//    label.textColor = DSKitAsset.Color.neutral50.color
//    label.font = UIFont.thtP2R
//    return label
//  }()
//
//  var sections: [ProfileDetailSection] = [] {
//    didSet {
//      DispatchQueue.main.async {
//        self.collectionView.reloadData()
//      }
//    }
//  }
//
//  public lazy var collectionView: UICollectionView = {
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .vertical
//    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.contentInsetAdjustmentBehavior = .always
//    collectionView.register(cellType: TagCollectionViewCell.self)
//    collectionView.register(cellType: ProfileIntroduceCell.self)
//    collectionView.register(cellType: InfoCVCell.self)
//    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
//    collectionView.register(viewType: TFNoneCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
//    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
//    collectionView.isScrollEnabled = false
//    collectionView.dataSource = self
//    collectionView.delegate = self
//    return collectionView
//  }()
//
//  public lazy var reportButton: UIButton = {
//    let button = UIButton()
//    var config = UIButton.Configuration.plain()
//    config.image = DSKitAsset.Image.Icons.reportFill.image.withTintColor(
//      DSKitAsset.Color.neutral50.color,
//      renderingMode: .alwaysOriginal
//    )
//    config.imagePlacement = .all
//    config.baseBackgroundColor = DSKitAsset.Color.topicBackground.color
//    button.configuration = config
//
//    config.automaticallyUpdateForSelection = true
//    return button
//  }()
//
//  public override func makeUI() {
//    self.backgroundColor = DSKitAsset.Color.neutral600.color
//    self.addSubviews([
//      titleLabel,
//      pinImageView, addressLabel,
//      collectionView, reportButton])
//
//    titleLabel.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(Metric.horizontalPadding)
//      $0.leading.equalToSuperview().offset(Metric.horizontalPadding)
//    }
//
//    pinImageView.snp.makeConstraints {
//      $0.top.equalTo(titleLabel.snp.bottom)
//      $0.leading.equalTo(titleLabel).offset(-1)
//    }
//    addressLabel.snp.makeConstraints {
//      $0.centerY.equalTo(pinImageView)
//      $0.leading.equalTo(pinImageView.snp.trailing)
//    }
//
//    collectionView.snp.makeConstraints {
//      $0.top.equalTo(addressLabel.snp.bottom)
//      $0.leading.trailing.bottom.equalToSuperview().inset(Metric.horizontalPadding)
//    }
//
//    reportButton.snp.makeConstraints {
//      $0.centerY.equalTo(titleLabel)
//      $0.trailing.equalToSuperview().inset(Metric.horizontalPadding)
//      $0.size.equalTo(24)
//    }
//  }
//
//  public func bind(_ userInfo: UserInfo) {
//    self.titleLabel.text = userInfo.description
//    self.addressLabel.text = userInfo.address
//
//    self.sections = [
//      .emoji("관심사", userInfo.idealTypeList),
//      .emoji("이상형", userInfo.interestsList),
//      .blocks([
//        ("키", "162cm"),
//        ("흡연", "비흡연"),
//        ("술", "아주 가끔"),
//        ("종교", "무교"),
//      ]),
//      .text("자기소개", userInfo.introduction)
//    ]
//  }
//}
//
//extension ProfileInfoView: UICollectionViewDelegateFlowLayout {
//  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    if section == 2 {
//      return CGSize(width: 0, height: 14)
//    }
//    return CGSize(width: collectionView.frame.width, height: 50)
//  }
//}
//
//extension ProfileInfoView: UICollectionViewDataSource {
//
//  public func numberOfSections(in collectionView: UICollectionView) -> Int {
//    self.sections.count
//  }
//  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    self.sections[section].count
//  }
//
//  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    switch sections[indexPath.section] {
//    case let .text(_, content):
//      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
//      cell.bind(content)
//      return cell
//    case let .emoji(_, emojis):
//      let item = emojis[indexPath.item]
//      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
//      cell.bind(.init(emojiCode: item.emojiCode, title: item.name))
//      return cell
//    case let .blocks(items):
//      let (title, content) = items[indexPath.item]
//      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: InfoCVCell.self)
//      cell.bind(title, content)
//      return cell
//    case .photo(_):
//      <#code#>
//    }
//  }
//
//  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//    if indexPath.section == 1 {
//      let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: ProfileInfoReusableView.self)
//
//      header.bind(title: <#T##String#>, subtitle: <#T##String#>)
//      return header
//    }
//    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
//    header.title = self.sections[indexPath.section].sectionTitle
//    return header
//  }
//}
