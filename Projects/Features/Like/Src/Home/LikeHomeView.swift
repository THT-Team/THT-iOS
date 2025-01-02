//
//  LikeHomeView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import Core
import DSKit

final class HeartListView: TFBaseView {
  private lazy var blurEffect = UIBlurEffect(style: .regular)
  lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)

  var needPaging: Bool {
    collectionView.contentOffset.y + collectionView.frame.height > collectionView.contentSize.height - 100
  }

  let headerLabel: UILabel = {
    let label = UILabel()
    label.font = .thtSubTitle1Sb
    label.backgroundColor = DSKitAsset.Color.neutral900.color
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.text = "무디 100명이 나를 좋아해요 :)"
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    return label
  }()

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
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    self.addSubviews(headerLabel, collectionView, visualEffectView)

    visualEffectView.isHidden = true
    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    // FIXME: 수치
    headerLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalToSuperview().offset(10)
      $0.height.equalTo(42)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
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
