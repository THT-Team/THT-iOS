//
//  TFBaseTableViewCell.swift
//  DSKit
//
//  Created by Kanghos on 6/15/24.
//

import UIKit

import RxSwift

open class TFBaseTableViewCell: UITableViewCell {

  public var disposeBag = DisposeBag()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    makeUI()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func prepareForReuse() {
    self.disposeBag = DisposeBag()
    super.prepareForReuse()
  }

  open func makeUI() { }
}
