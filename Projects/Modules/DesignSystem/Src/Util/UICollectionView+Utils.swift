//
//  UICollectionView+Utils.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

extension UICollectionViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}

public extension UICollectionView {

  func register<T: UICollectionViewCell>(cellType: T.Type) {
    self.register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  func register<T: UICollectionReusableView>(viewType: T.Type, kind: String) {
    self.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable cell")
    }
    return cell
  }
  func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath, ofKind elementKind: String, viewType: T.Type = T.self) -> T {
    guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable view")
    }
    return reusableView
  }
}

extension Reactive where Base: UICollectionView {
  public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
  (cellType: Cell.Type = Cell.self)
  -> (_ source: Source)
  -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
  -> Disposable where Source.Element == Sequence {
    return self.items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
  }
}
