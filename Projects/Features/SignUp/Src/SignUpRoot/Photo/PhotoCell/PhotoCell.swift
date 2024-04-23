//
//  PhotoCell.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

import RxCocoa
import RxSwift

final class PhotoCell: TFBaseCollectionViewCell {
  private var image: UIImage?

  lazy var imageView = UIImageView().then {
    $0.layer.cornerRadius = 14
    $0.contentMode = .scaleAspectFill
  }

  lazy var addButton = UIButton.plusButton

  override func makeUI() {
    contentView.addSubview(addButton)
    contentView.addSubview(imageView)

    contentView.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    contentView.layer.borderWidth = 2
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 10

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    addButton.snp.makeConstraints {
      $0.width.equalTo(52)
      $0.height.equalTo(24)
      $0.center.equalToSuperview()
    }
  }

  func bind(_ viewModel: PhotoCellViewModel) {
    if let data = viewModel.data {
      self.imageView.image = UIImage(data: data)
    } else {
      self.imageView.image = nil
    }

    contentView.layer.borderColor = viewModel.cellType == .required
    ? DSKitAsset.Color.primary500.color.cgColor
    : DSKitAsset.Color.neutral400.color.cgColor
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.imageView.image = nil
  }
}

