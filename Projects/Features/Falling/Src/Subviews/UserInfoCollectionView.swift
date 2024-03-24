//
//  UserInfoView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import UIKit

import Core
import DSKit
import FallingInterface
import Domain

final class UserInfoView: TFBaseView {
  private var dataSource: DataSource!
  
  lazy var reportButton: UIButton = {
    let button = UIButton()
    button.setImage(DSKitAsset.Image.Icons.reportFill.image, for: .normal)
    return button
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.horizontalTagLayout(withEstimatedHeight: 46)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    collectionView.contentInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 6, right: 12)
    return collectionView
  }()
  
  override func makeUI() {
    addSubview(collectionView)
    addSubview(reportButton)
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    reportButton.snp.makeConstraints {
      $0.trailing.top.equalToSuperview().inset(12)
    }
    
    setDataSource()
  }
  
  func bind(_ item: FallingUser) {
    let ideals = item.idealTypeResponseList.map { FallingUserInfoItem.ideal($0) }
    let interests = item.interestResponses.map { FallingUserInfoItem.interest($0) }
    let introductions = [FallingUserInfoItem.introduction(item.introduction)]
    
    var snapshot = Snapshot()
    snapshot.appendSections([.ideal, .interest, .introduction])
    snapshot.appendItems(ideals, toSection: .ideal)
    snapshot.appendItems(interests, toSection: .interest)
    snapshot.appendItems(introductions, toSection: .introduction)
    dataSource.apply(snapshot)
  }
}

// MARK: DiffableDataSource

extension UserInfoView {
  typealias ModelType = FallingUserInfoItem
  typealias SectionType = FallingUserInfoSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
  
  func setDataSource()  {
    let headerRegistration = UICollectionView.SupplementaryRegistration
    <UserInfoHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
      supplementaryView, elementKind, indexPath in
      guard let sectionType = FallingUserInfoSection(rawValue: indexPath.section) else { return }
      supplementaryView.titleLabel.text = sectionType.title
    }
    
    let tagCellRegistration = UICollectionView.CellRegistration<TagCollectionViewCell, EmojiType> { cell, indexPath, item in
      cell.bind(item)
    }
    
    let introductionCellRegistration = UICollectionView.CellRegistration<ProfileIntroduceCell, String> { cell, indexPath, item in
      cell.bind(item)
    }
    
    dataSource = DataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch itemIdentifier {
      case .ideal(let item), .interest(let item):
        return collectionView.dequeueConfiguredReusableCell(using: tagCellRegistration, for: indexPath, item: item)
      case .introduction(let item):
        return collectionView.dequeueConfiguredReusableCell(using: introductionCellRegistration, for: indexPath, item: item)
      }
    })
    
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration,
        for: index
      )
    }
  }
}

extension UICollectionViewCompositionalLayout {
  static func horizontalTagLayout(withEstimatedHeight estimatedHeight: CGFloat = 46) -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout(section: .horizontalTagSection(withEstimatedHeight: estimatedHeight))
  }
}

extension NSCollectionLayoutSection {
  static func horizontalTagSection(withEstimatedHeight estimatedHeight: CGFloat = 46) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(40),
      heightDimension: .estimated(estimatedHeight)
    )
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let layoutGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(estimatedHeight)
    )
    
    let layoutGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: layoutGroupSize,
      subitems: [layoutItem]
    )
    layoutGroup.interItemSpacing = .fixed(6) // 아이템 간격
    
    let sectionHeaderSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(17))
    
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: sectionHeaderSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
    )
    
    let section = NSCollectionLayoutSection(group: layoutGroup)
    // 섹션 간격
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 4,
      leading: 0,
      bottom: 6,
      trailing: 0
    )
    section.boundarySupplementaryItems = [sectionHeader]
    section.interGroupSpacing = 6 // 행 간격
    return section
  }
}
