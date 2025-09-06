//
//  TFCarouselView.swift
//  Falling
//
//  Created by Kanghos on 6/29/24.
//

import Foundation

import UIKit  

import DSKit

final class TFCarouselView: TFBaseView {
  
  lazy var collectionView = TFBaseCollectionView(frame: .zero, collectionViewLayout: createLayout())
  
  lazy var pageControl = UIPageControl().then {
    let normalDot = circleImage(diameter: 6, color: DSKitAsset.Color.neutral50.color)
    let currentDot = circleImage(diameter: 6, color: DSKitAsset.Color.neutral300.color)
    
    $0.backgroundStyle = .minimal
    $0.allowsContinuousInteraction = false
    $0.preferredIndicatorImage = normalDot
    
    guard $0.numberOfPages > 0 else { return }
    
    for i in 0..<$0.numberOfPages {
      $0.setIndicatorImage(normalDot, forPage: i)
    }
    $0.setIndicatorImage(currentDot, forPage: $0.currentPage)
  }
  
  func register<T: UICollectionViewCell>(cellType: T.Type) {
    collectionView.register(cellType: cellType.self)
  }
  
  override func makeUI() {
    collectionView.isScrollEnabled = false
    
    addSubviews(collectionView, pageControl)
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    pageControl.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(6)
      $0.bottom.equalToSuperview().inset(12)
    }
  }
  
  // MARK: pageControl
  private func createLayout() -> UICollectionViewLayout {
    let sectionLayout: NSCollectionLayoutSection = .horizontalListSection()
    sectionLayout.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
      guard let self = self else { return }
      let containerWidth = self.collectionView.bounds.width
      let midX = offset.x + containerWidth / 2
      
      let target = items.min(by: {
        abs($0.frame.midX - midX) < abs($1.frame.midX - midX)
      })
      
      if let index = target?.indexPath.item, self.pageControl.currentPage != index {
        self.pageControl.currentPage = index
      }
    }
    return UICollectionViewCompositionalLayout(section: sectionLayout)
  }
  
  private func circleImage(diameter: CGFloat, color: UIColor) -> UIImage {
    let r = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
    return r.image { ctx in
      color.setFill()
      UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter)).fill()
    }.withRenderingMode(.alwaysOriginal)
  }
}
