//
//  TagCollectionView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

public final class TagCollectionView: TFBaseView {
  public lazy var sections: [ProfileInfoSection] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }

  public lazy var collectionView: UICollectionView = {
    let layout = LeftAlignCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.headerReferenceSize = CGSize(width: 200, height: 50)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.register(cellType: ProfileIntroduceCell.self)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    collectionView.dataSource = self
    return collectionView
  }()

  public override func makeUI() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension TagCollectionView: UICollectionViewDataSource {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section < 2 else {
      return 1
    }
    return self.sections[section].items.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0, 1:
      let item = self.sections[indexPath.section].items[indexPath.item]
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
      cell.bind(TagItemViewModel(emojiCode: item.emojiCode, title: item.name))
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
      cell.bind(self.sections[indexPath.section].introduce)
      return cell
    }
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sections[indexPath.section].header
    return header
  }
}
