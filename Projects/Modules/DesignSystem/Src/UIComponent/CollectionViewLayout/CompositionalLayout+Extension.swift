//
//  CompositionalLayout+Extension.swift
//  DSKit
//
//  Created by Kanghos on 6/11/24.
//

import UIKit

public extension UICollectionViewCompositionalLayout {
  static func listLayout(withEstimatedHeight estimatedHeight: CGFloat = 110) -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout(section: .listSection(withEstimatedHeight: estimatedHeight))
    }
  static func listLayoutAutomaticHeight(withEstimatedHeight estimatedHeight: CGFloat = 110) -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout(section:
            .listEstimatedHeightSection(withEstimatedHeight: estimatedHeight))
  }
}

public extension NSCollectionLayoutSection {

  static func listSection(withEstimatedHeight estimatedHeight: CGFloat = 110) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//    layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

    let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
    layoutGroup.interItemSpacing = .fixed(10)

    return NSCollectionLayoutSection(group: layoutGroup)
  }

  static func listEstimatedHeightSection(withEstimatedHeight estimatedHeight: CGFloat = 110) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//    layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

    let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
    layoutGroup.interItemSpacing = .fixed(10)

    return NSCollectionLayoutSection(group: layoutGroup)
  }
}
