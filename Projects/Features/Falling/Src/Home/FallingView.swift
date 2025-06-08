//
//  FallingView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit
import SwiftUI

import Core
import DSKit

final class FallingView: TFBaseView {
  let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewCompositionalLayout.verticalListLayout(withEstimatedHeight: ((UIWindow.keyWindow?.frame.width ?? 0) - 32) * 1.64)
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: flowLayout)
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    return collectionView
  }()
  
  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    
    self.addSubview(collectionView)
    
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension UICollectionViewCompositionalLayout {
  static func verticalListLayout(withEstimatedHeight estimatedHeight: CGFloat = 110) -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout(section: .verticalListSection(withEstimatedHeight: estimatedHeight))
  }
  
  static func horizontalListLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout(section: .horizontalListSection())
  }
}

extension NSCollectionLayoutSection {
  static func verticalListSection(withEstimatedHeight estimatedHeight: CGFloat = 110) -> NSCollectionLayoutSection {
    let hasChosenDailyTopic = UserDefaultRepository.shared.fetch(for: .hasChosenDailyTopic, type: Bool.self) ?? false
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let layoutGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: hasChosenDailyTopic ? .fractionalHeight(586/(844 - 180)) : .fractionalHeight(1.0)
    )
    
    let layoutGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: layoutGroupSize,
      subitems: [layoutItem]
    )
    layoutGroup.contentInsets = NSDirectionalEdgeInsets(
      top: 8,
      leading: 16,
      bottom: 8,
      trailing: 16
    )
    
    let footerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(586/(844 - 180)))
    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: footerSize,
        elementKind: UICollectionView.elementKindSectionFooter, 
        alignment: .bottom
    )
    
    let section = NSCollectionLayoutSection(group: layoutGroup)
    section.interGroupSpacing = 14
    
    if hasChosenDailyTopic {
      section.boundarySupplementaryItems = [sectionFooter]
    } else {
      section.boundarySupplementaryItems = []
    }
    
    section.visibleItemsInvalidationHandler = { item, offset, environment in
      
    }
    return section
  }
  
  static func horizontalListSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let layoutGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    
    let layoutGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: layoutGroupSize,
      subitems: [layoutItem]
    )
    
    let section = NSCollectionLayoutSection(group: layoutGroup)
    section.orthogonalScrollingBehavior = .paging

    section.visibleItemsInvalidationHandler = { items, offset, environment in

    }

    return section
  }
}

extension FallingView {
  func scrollto(_ indexPath: IndexPath) {
    guard let _ = self.collectionView.cellForItem(at: indexPath) else {
      TFLogger.ui.debug("Falied to scroll to item at: \(indexPath)")
      return
    }
    collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    TFLogger.ui.debug("scroll to Item at: \(indexPath)")
  }
}
