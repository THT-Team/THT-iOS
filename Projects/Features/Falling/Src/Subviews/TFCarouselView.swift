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

  lazy var carouselView = TFBaseCollectionView(frame: .zero, collectionViewLayout: createLayout())

  lazy var pageControl = UIPageControl().then {
    $0.currentPageIndicatorTintColor = .black
    $0.pageIndicatorTintColor = .gray
  }

  func register<T: UICollectionViewCell>(cellType: T.Type) {
    carouselView.register(cellType: cellType.self)
  }

  override func makeUI() {
    carouselView.isScrollEnabled = false

    addSubviews(carouselView, pageControl)

    carouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(30)
      $0.bottom.equalToSuperview().inset(10)
    }
  }

  // MARK: pageControl
  func createLayout() -> UICollectionViewLayout {
    let sectionLayout: NSCollectionLayoutSection = .horizontalListSection()
    sectionLayout.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
      guard let self = self else { return }
      let index = Int(offset.x / self.carouselView.frame.width)
      self.pageControl.currentPage = index
    }
    return UICollectionViewCompositionalLayout(section: sectionLayout)
  }
}
