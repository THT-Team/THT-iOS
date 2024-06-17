//
//  LeftAlignCollectionViewLayout.swift
//  DSKit
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

public class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {

  let cellSpacing: CGFloat = 10
  let sidePadding: CGFloat

  public init(sidePadding: CGFloat = 10) {
    self.sidePadding = sidePadding
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    self.minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 0, left: sidePadding, bottom: 0, right: sidePadding)

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
