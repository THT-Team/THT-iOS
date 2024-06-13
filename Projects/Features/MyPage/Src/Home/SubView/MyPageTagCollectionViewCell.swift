//
//  MyPageTagCollectionViewCell.swift
//  MyPage
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

import DSKit

import Then
import SnapKit
import Domain
import MyPageInterface

final class MyPageTagCollectionViewCell: TFBaseCollectionViewCell {
  var model: MyPageInfoCollectionViewCellViewModel?

  private lazy var titleLabel = UILabel().then {
    $0.font = UIFont.thtSubTitle1Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "타이틀 텍스트"
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }

  private var datasource: [TagItemViewModel] = [] {
    didSet {
      tagCollectionView.reloadData()
    }
  }

  private lazy var tagCollectionView: UICollectionView = {
      let layout = RightAlignCollectionViewFlowLayout(sidePadding: 5)
      layout.estimatedItemSize =  UICollectionViewFlowLayout.automaticSize
      let collectionView = MyPageTagCollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.register(cellType: TagCollectionViewCell.self)

      collectionView.backgroundColor =  DSKitAsset.Color.neutral600.color
      collectionView.isScrollEnabled = false
      collectionView.dataSource = self
      return collectionView
  }()

  private lazy var containerView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral600.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }

  override func makeUI() {
    contentView.addSubviews(containerView)
    contentView.backgroundColor = .clear
    containerView.addSubviews(titleLabel, tagCollectionView)

    containerView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-5)
      $0.top.equalToSuperview().offset(5)
      $0.leading.trailing.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(15)
    }

    tagCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel).offset(5)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().offset(-10)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }

  public func bind(_ viewModel: MyPageInfoCollectionViewCellViewModel) {
    titleLabel.text = viewModel.title
    self.model = viewModel
    guard let tags = viewModel.content as? [TagItemViewModel] else {
      datasource = []
      return
    }
    datasource = tags
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    self.layoutIfNeeded()
    let contentSize = tagCollectionView.collectionViewLayout.collectionViewContentSize
    return CGSize(width: targetSize.width, height: contentSize.height)
  }
}

extension MyPageTagCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datasource.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
    let tag = datasource[indexPath.item]

    cell.bind(tag)
    cell.setFont(.thtP2M)

    return cell
  }
}
