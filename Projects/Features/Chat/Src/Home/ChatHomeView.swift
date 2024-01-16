//
//  ChatListEmptyView.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/10.
//

import UIKit

import Core
import DSKit

final class ChatHomeView: TFBaseView {
  lazy var notiButton: UIBarButtonItem = .noti
  lazy var backgroundView = TFEmptyView(
    image: DSKitAsset.Bx.noMudy.image,
    title: "진행중인 대화가 없어요.",
    subTitle: "먼저 마음에 잘 맞는 무디들을 찾아볼까요?", 
    buttonTitle: "무디들 만나러 가기"
  )

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.listLayout(withEstimatedHeight: 80)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundView = backgroundView
    collectionView.refreshControl = self.refreshControl
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    return collectionView
  }()

  lazy var refreshControl = UIRefreshControl()

  override func makeUI() {
    self.addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatListEmptyViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return ChatHomeView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif

extension UICollectionViewCompositionalLayout {
  static func listLayout(withEstimatedHeight estimatedHeight: CGFloat = 110) -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout(section: .listSection(withEstimatedHeight: estimatedHeight))
    }
  static func listLayoutAutomaticHeight(withEstimatedHeight estimatedHeight: CGFloat = 110) -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout(section:
            .listEstimatedHeightSection(withEstimatedHeight: estimatedHeight))
  }
}

extension NSCollectionLayoutSection {

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
