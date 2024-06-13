//
//  CollectionViewLayout+Util.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

extension UICollectionViewLayout {
  static func photoPickLayout(edge: CGFloat = 5) -> UICollectionViewLayout {
    let edgeInset = NSDirectionalEdgeInsets(top: edge, leading: edge, bottom: edge, trailing: edge)

    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

      let leadingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65),
                                           heightDimension: .fractionalHeight(1.0)))
      leadingItem.contentInsets = edgeInset

      let trailingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(0.5)))
      trailingItem.contentInsets = edgeInset

      let trailingGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                           heightDimension: .fractionalHeight(1.0)),
        repeatingSubitem: trailingItem, count: 2)

      let nestedGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0)),
        subitems: [leadingItem, trailingGroup])
      let section = NSCollectionLayoutSection(group: nestedGroup)
      return section

    }
    return layout
  }
}

