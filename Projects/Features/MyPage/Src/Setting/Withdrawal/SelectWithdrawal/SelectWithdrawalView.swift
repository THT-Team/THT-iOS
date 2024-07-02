//
//  SelectWithdrawalView.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/3/24.
//

import UIKit

import DSKit

final class SelectWithdrawalView: TFBaseView {
  private lazy var titleView = TFTitleView(title: "계정 탈퇴하시겠어요?", subTitle: "탈퇴하시는 이유를 알려주세요")

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 12
    layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(cellType: WithdrawalCollectionViewCell.self)
    cv.backgroundColor = DSKitAsset.Color.neutral700.color
    return cv
  }()

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    addSubviews(titleView, collectionView)

    titleView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(40)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}
