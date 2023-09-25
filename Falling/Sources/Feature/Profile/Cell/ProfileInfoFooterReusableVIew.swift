//
//  ProfileInfoFooterReusableVIew.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import UIKit

import SnapKit

final class ProfileInfoReusableView: UICollectionReusableView {
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtH1B
    return label
  }()
  private var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.delegate = self
//    collectionView.dataSource = self
    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubview(collectionView)
    self.addSubview(nameLabel)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    nameLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(15)
    }
  }

  func configure(info: HeartUserResponse) {
    TFLogger.view.debug("\(info.username)")
    self.nameLabel.text = "최지인 받음"
  }
}

