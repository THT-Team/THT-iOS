//
//  TagCollectionView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/11/24.
//

import UIKit
import DSKit

final class TagsPickerView: TFBaseView {

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

  var height: NSLayoutConstraint?

  private(set) lazy var tagCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()// RightAlignCollectionViewFlowLayout(sidePadding: 5)
      layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
//    addSubviews(containerView)
//    backgroundColor = .clear
//    containerView.addSubviews(titleLabel)
//    containerView.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(5)
//      $0.leading.trailing.equalToSuperview()
//    }
//    addSubviews(tagCollectionView)
//
//    titleLabel.snp.makeConstraints {
//      $0.top.leading.equalToSuperview().offset(15)
//      $0.height.equalTo(40)
//      $0.trailing.bottom.equalToSuperview()
//    }
    addSubview(tagCollectionView)

    tagCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(50)
      $0.leading.equalToSuperview().offset(100)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(40).priority(.low)
    }
  }

  public func bind(_ viewModel: MyPageInfoCollectionViewCellViewModel) {
    titleLabel.text = viewModel.title

   
  }

  
}

extension TagsPickerView: UICollectionViewDataSource {
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
