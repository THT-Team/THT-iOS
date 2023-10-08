//
//  TFBaseCollectionViewCell.swift
//  Falling
//
//  Created by SeungMin on 2023/10/02.
//

import UIKit

import RxSwift

class TFBaseCollectionViewCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
  
  func makeUI() { }
}
