//
//  TagCollectionView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/02.
//

import UIKit

import SnapKit

final class TagCollectionView: TFBaseView {

  lazy var collectionView: UICollectionView = {
    let layout = LeftAlignCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.headerReferenceSize = CGSize(width: 200, height: 50)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.register(cellType: ProfileIntroduceCell.self)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = FallingAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    return collectionView
  }()

  override func makeUI() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {

  let cellSpacing: CGFloat = 10

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    self.minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
      let attributes = super.layoutAttributesForElements(in: rect)

      var xPosition = sectionInset.left // Left Maring cell 추가하면 변경하고 line count에 따라 초기화
      var lineCount = -1.0 // lineCount

      // lineCount해서 전체 레이아웃을 넘어가면 line 증가
      attributes?.forEach { attribute in
        if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
          attribute.frame.origin.x = sectionInset.left
          return
        }
        if attribute.indexPath.section == 2 { // 자기소개 셀
          return
        }
        if attribute.frame.origin.y >= lineCount { // xPosition 초기화
          xPosition = sectionInset.left
        }
        attribute.frame.origin.x = xPosition
        xPosition += attribute.frame.width + cellSpacing
        lineCount = max(attribute.frame.maxY, lineCount)
      }
      return attributes
}
}
