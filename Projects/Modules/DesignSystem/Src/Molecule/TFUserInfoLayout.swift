//
//  TFUserInfoLayout.swift
//  DSKit
//
//  Created by Kanghos on 2/5/25.
//

import UIKit

extension UICollectionView {
  public static func createCardUserCollectionView() -> UICollectionView {
    let layout: UICollectionViewLayout = .crateCardUserCVLayout()

    let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(cellType: TagCollectionViewCell.self)
    cv.register(cellType: InfoCVCell.self)
    cv.register(cellType: ProfileIntroduceCell.self)
    cv.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    cv.layer.cornerRadius = 12
    cv.clipsToBounds = true
    return cv
  }
}

extension UICollectionViewLayout {
  static func crateCardUserCVLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { index, environment in
      Self.createCardUserSsection(index)
    }
    layout.configuration.interSectionSpacing = 0
    return layout
  }

  static func createCardUserSsection(_ index: Int) -> NSCollectionLayoutSection? {
    switch index {
    case 0: return createEmojiSection() // Interest
    case 1: return createEmojiSection() // IdealType
    case 2: return createInfoSection()// Info
    case 3: return createIntroduceSection()
    default: return nil
    }
  }
}
