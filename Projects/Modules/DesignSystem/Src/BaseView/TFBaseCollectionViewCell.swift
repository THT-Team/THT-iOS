//
//  TFBaseCollectionViewCell.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

open class TFBaseCollectionViewCell: UICollectionViewCell {

  public var disposeBag = DisposeBag()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }

  open func makeUI() { }
}
