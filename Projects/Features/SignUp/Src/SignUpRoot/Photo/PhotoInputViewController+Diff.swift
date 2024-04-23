//
//  PhotoInputViewController+Diff.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

extension PhotoInputViewController {
  enum Section {
    case main
  }

  typealias CellType = PhotoCell
  typealias SectionType = Section
  typealias ModelType = PhotoCellViewModel
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>

  func configureDataSource() {
      let cellRegistration = UICollectionView.CellRegistration<PhotoCell, ModelType> { (cell, indexPath, model) in
        cell.bind(model)
      }
    dataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>(collectionView: mainView.photoCollectionView) {
          (collectionView: UICollectionView, indexPath: IndexPath, model: ModelType) -> UICollectionViewCell? in
          // Return the cell.
          return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
      }

      // initial data
      var snapshot = Snapshot()
      snapshot.appendSections([Section.main])
      snapshot.appendItems([])
      dataSource.apply(snapshot, animatingDifferences: false)
  }

  func updateSnapshot(items: [ModelType]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.applySnapshotUsingReloadData(snapshot)
  }
}
