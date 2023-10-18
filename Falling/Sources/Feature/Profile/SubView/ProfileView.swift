//
//  ProfileView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit

import SnapKit

final class ProfileView: TFBaseView {

  lazy var topicBarView = TFTopicBarView()

  lazy var profileCollectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor  = FallingAsset.Color.disabled.color
    collectionView.layer.cornerRadius = 12
    collectionView.clipsToBounds = true
    return collectionView
  }()

  lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral50.color
    config.baseBackgroundColor = FallingAsset.Color.neutral500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    return stackView
  }()

  lazy var chatButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral700.color
    config.baseBackgroundColor = FallingAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  override func makeUI() {
    [topicBarView, profileCollectionView, stackView].forEach {
      self.addSubview($0)
    }
    stackView.addArrangedSubview(nextTimeButton)
    stackView.addArrangedSubview(chatButton)

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }

    stackView.snp.makeConstraints {
      $0.centerY.equalTo(profileCollectionView.snp.bottom)
      $0.leading.trailing.equalTo(profileCollectionView).inset(10)
      $0.height.equalTo(46)
    }
  }

  func createLayout() -> UICollectionViewLayout {
    let estimatedHeight = CGFloat(600)
    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    section.interGroupSpacing = 0

    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(500)
    )
    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )
    section.boundarySupplementaryItems = [sectionFooter]

    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}

