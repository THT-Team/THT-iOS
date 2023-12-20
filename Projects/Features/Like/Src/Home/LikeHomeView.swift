//
//  LikeHomeView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import Core
import SnapKit

import DSKit

final class HeartListView: TFBaseView {
  private lazy var blurEffect = UIBlurEffect(style: .regular)
  lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)

  var needPaging: Bool {
    collectionView.contentOffset.y + collectionView.frame.height > collectionView.contentSize.height - 100
  }

  lazy var collectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    collectionView.backgroundView = self.emptyView
    collectionView.refreshControl = self.refreshControl
    return collectionView
  }()

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()

  let emptyView = TFEmptyView(
    image: DSKitAsset.Bx.noLike.image,
    title: "아직 만난 무디가 없네요.",
    subTitle: "먼저 마음이 잘 맞는 무디들을 찾아볼까요?",
    buttonTitle: "무디들 만나러 가기"
  )

  override func makeUI() {
    self.addSubview(collectionView)
    self.addSubview(visualEffectView)

    visualEffectView.isHidden = true
    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }
  }

  func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    let bound = UIScreen.main.bounds
    let width = bound.width - 14 * 2
    let height = width * (108 / 358)
    layout.itemSize = CGSize(width: width, height: height)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .vertical

    return layout
  }
}
