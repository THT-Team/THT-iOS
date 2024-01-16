//
//  FallingHomeView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit

final class FallingHomeView: TFBaseView {
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 14
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: flowLayout)
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    return collectionView
  }()
  
  override func makeUI() {
    self.addSubview(collectionView)
    
    self.collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.bottom.trailing.equalToSuperview()
    }
  }
}
