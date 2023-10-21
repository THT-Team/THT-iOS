//
//  MainView.swift
//  Falling
//
//  Created by SeungMin on 2023/09/10.
//

import UIKit

import RxSwift
import SnapKit

final class MainView: TFBaseView {
  
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 14
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: flowLayout)
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = FallingAsset.Color.neutral700.color
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
