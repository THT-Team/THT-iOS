//
//  CollectionViewLayout+Util.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit
import DSKit

extension UICollectionViewLayout {
  static func photoPickLayout(edge: CGFloat = 5) -> UICollectionViewLayout {
    let edgeInset = NSDirectionalEdgeInsets(top: edge, leading: edge, bottom: edge, trailing: edge)

    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let leadingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                           heightDimension: .fractionalHeight(1.0)))
//      leadingItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16.adjusted)

      let trailingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(0.5)))
//      trailingItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

      let trailingGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                           heightDimension: .fractionalHeight(1.0)),
        repeatingSubitem: trailingItem, count: 2)
      trailingGroup.interItemSpacing = .fixed(14.adjustedH)

      let nestedGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0)),
        subitems: [leadingItem, trailingGroup])
      nestedGroup.interItemSpacing = .fixed(16.adjusted)
      let section = NSCollectionLayoutSection(group: nestedGroup)
      return section

    }
    return layout
  }
}

