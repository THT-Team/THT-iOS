//
//  ProfileView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit
import Core
import DSKit

final class ProfileView: TFBaseView {

  lazy var topicBarView = TFTopicBarView()
  lazy var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))


  lazy var profileCollectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: ProfileCollectionViewCell.self)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.register(cellType: ProfileIntroduceCell.self)
    collectionView.register(cellType: InfoCVCell.self)
    collectionView.register(viewType: ProfileInfoReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor  = DSKitAsset.Color.neutral600.color
    collectionView.layer.cornerRadius = 12
    collectionView.clipsToBounds = true
    return collectionView
  }()

  lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral50.color
    config.baseBackgroundColor = DSKitAsset.Color.neutral500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    return stackView
  }()

  lazy var chatButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral700.color
    config.baseBackgroundColor = DSKitAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  override func makeUI() {
    self.backgroundColor = .clear
    [topicBarView, profileCollectionView, stackView, visualEffectView].forEach {
      self.addSubview($0)
    }
    visualEffectView.isHidden = true
    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    stackView.addArrangedSubview(nextTimeButton)
    stackView.addArrangedSubview(chatButton)

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }

    stackView.snp.makeConstraints {
      $0.centerY.equalTo(profileCollectionView.snp.bottom)
      $0.leading.trailing.equalTo(profileCollectionView).inset(10)
      $0.height.equalTo(46)
    }
  }

  func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
      self?.createSection(index)
    }
    layout.configuration.interSectionSpacing = 0
    return layout
  }

  func createSection(_ index: Int) -> NSCollectionLayoutSection? {
    switch index {
    case 0:
      // Photo
      return createPhotoSection()
    case 1:
      // Emoji + Title
      return createEmojiSection()
    case 2:
      // Emoji
      return createEmojiSection()
    case 3:
      // Info
      return createInfoSection()
    case 4:
      // Introduce
      return createIntroduceSection()
    default: return nil
    }
  }

  func createPhotoSection() -> NSCollectionLayoutSection {
    let layoutSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(600))

    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)

    return section
  }

  func createEmojiSection() -> NSCollectionLayoutSection {
    let layoutSize = NSCollectionLayoutSize(
      widthDimension: .estimated(100),
      heightDimension: .estimated(50)
    )
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), repeatingSubitem: item, count: 3)
    group.interItemSpacing = .fixed(5)
    let section = NSCollectionLayoutSection(group: group)
    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(100)
    )
    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionFooter]
    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    return section
  }

  func createInfoSection() -> NSCollectionLayoutSection {
    let layoutSize = NSCollectionLayoutSize(
      widthDimension: .estimated(80),
      heightDimension: .estimated(80)
    )
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), repeatingSubitem: item, count: 4)
    group.interItemSpacing = .fixed(16)
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    return section
  }

  func createIntroduceSection() -> NSCollectionLayoutSection {
    let layoutSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(100)
    )
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(10)
    )
    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionFooter]
    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    return section
  }
}


