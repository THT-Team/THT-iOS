//
//  UserInfoView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import UIKit

import Core
import DSKit
import Domain

final class UserInfoView: TFBaseView {
  public var sections: [ProfileDetailSection] = []
  public var reportTap: (() -> Void)?
  public var reportButton = UIButton.createReportButton()
  public private(set) lazy var visualEffectView: UIVisualEffectView = {
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    return visualView
  }()

  lazy var collectionView: UICollectionView = .createCardUserCollectionView()

  enum Metric {
    static let horizontalPadding: CGFloat = 12.f
    static let verticalPadding: CGFloat = 12.f
  }

  override func makeUI() {
    self.collectionView.dataSource = self
    self.collectionView.isScrollEnabled = false
    self.collectionView.backgroundColor = .clear

    self.backgroundColor = .clear
    addSubviews(visualEffectView, collectionView, reportButton)

    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Metric.horizontalPadding)
      $0.top.bottom.equalToSuperview().inset(Metric.verticalPadding)
      $0.height.greaterThanOrEqualTo(100)
    }

    reportButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(Metric.horizontalPadding)
      $0.size.equalTo(24)
    }
  }
}

extension UserInfoView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    sections[section].count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print(sections)
    switch sections[indexPath.section] {
    case let .emoji(_, items, _):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
      let tag = items[indexPath.item]
      cell.bind(TagItemViewModel(emojiCode: tag.emojiCode, title: tag.name))
      return cell
    case let .blocks(items):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: InfoCVCell.self)
      let (title, content) = items[indexPath.item]
      cell.bind(title, content)
      return cell
    case let .text(_, content):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
      cell.bind(content)
      return cell
    case .photo(_):
      fatalError("aefasf")
    }
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
   
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sections[indexPath.section].sectionTitle
    return header
  }
}
