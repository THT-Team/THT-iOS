//
//  TFProfileLayout.swift
//  DSKit
//
//  Created by Kanghos on 1/28/25.
//

import UIKit

extension UICollectionView {
  public static func createProfileCollectionView() -> UICollectionView {
    let layout: UICollectionViewLayout = .createProfileCVLayout()
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
  }
}

extension UICollectionViewLayout {
  public static func createProfileCVLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { index, environment in
      Self.createProfileSection(index)
    }
    layout.configuration.interSectionSpacing = 0
    return layout
  }

  static func createProfileSection(_ index: Int) -> NSCollectionLayoutSection? {
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

  public static func createPhotoSection() -> NSCollectionLayoutSection {
    let layoutSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(600))

    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)

    return section
  }

  static func createEmojiSection() -> NSCollectionLayoutSection {
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

  static func createInfoSection() -> NSCollectionLayoutSection {
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

  static func createIntroduceSection() -> NSCollectionLayoutSection {
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
