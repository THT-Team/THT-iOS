//
//  TFProfileView.swift
//  DSKit
//
//  Created by Kanghos on 1/28/25.
//

import UIKit
import Core

open class TFProfileView: TFBaseView {

  public var sections = [ProfileDatailSection]()
  public var reportTap: (() -> Void)?

  public private(set) lazy var topicBarView = TFTopicBarView()

  public private(set) lazy var profileCollectionView: UICollectionView = .createProfileCollectionView()

  public override func makeUI() {
    self.profileCollectionView.dataSource = self

    self.backgroundColor = .clear
    [topicBarView, profileCollectionView].forEach {
      self.addSubview($0)
    }

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }
  }
}

extension TFProfileView: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    sections.count
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    sections[section].count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch sections[indexPath.section] {
    case let .photo(items):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileCollectionViewCell.self)
      cell.bind(imageURL: items[indexPath.item].url)
      return cell
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
    }
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if
      indexPath.section == 1,
      case let .emoji(sectionName, _, title) = sections[indexPath.section] {
      let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: ProfileInfoReusableView.self)

      header.reportButton.rx.tap.asSignal()
        .emit(with: self, onNext: { owner, _ in
          owner.reportTap?()
        })
        .disposed(by: header.disposeBag)

      header.bind(title: title?.0, subtitle: title?.1, header: sectionName)
      return header
    }
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sections[indexPath.section].sectionTitle
    return header
  }
}

extension Reactive where Base: TFProfileView {
  public var sections: Binder<[ProfileDatailSection]> {

    return Binder(base) { base, value in
      base.sections = value
    }
  }

  public var topicBar: Binder<TopicViewModel> {
    Binder(self.base) { base, value in
      base.topicBarView.bind(value)
    }
  }
}
