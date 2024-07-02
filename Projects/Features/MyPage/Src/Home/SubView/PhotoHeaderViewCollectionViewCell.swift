//
//  PhotoHeaderViewCollectionViewCell.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import UIKit

import DSKit

import RxCocoa
import RxSwift
import Kingfisher

final class PhotoHeaderViewCollectionViewCell: TFBaseCollectionViewCell {
  private var image: UIImage?

  var editButtonTap: (() -> Void)?
  var addButtonTap: (() -> Void)?
  lazy var imageView = UIImageView().then {
    $0.layer.cornerRadius = 14
    $0.contentMode = .scaleAspectFill
  }

  lazy var addButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.addWhite.image, for: .normal)
    $0.isUserInteractionEnabled = false
    $0.addAction(.init { [weak self] _ in self?.addButtonTap?() }, for: .touchUpInside)
  }

  lazy var editButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.editCircle.image, for: .normal)
    $0.isHidden = true
    $0.addAction(.init { [weak self] _ in self?.editButtonTap?() }, for: .touchUpInside)
  }

  override func makeUI() {
    contentView.addSubviews(addButton, imageView, editButton)
    contentView.backgroundColor = DSKitAsset.Color.neutral600.color
    contentView.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    contentView.layer.borderWidth = 1
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 10

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(1)
    }

    addButton.snp.makeConstraints {
      $0.size.equalTo(50)
      $0.center.equalToSuperview()
    }

    editButton.snp.makeConstraints {
      $0.size.equalTo(50)
      $0.trailing.bottom.equalToSuperview()
    }
  }

  func bind(_ viewModel: PhotoHeaderCellViewModel) {
    if let url = viewModel.url {
      self.imageView.setImage(url: url, downsample: self.imageView.frame.height)
      self.editButton.isHidden = false
    } else {
      self.imageView.image = nil
      self.editButton.isHidden = true
    }

    contentView.layer.borderWidth = viewModel.cellType == .required
    ? 1
    : 0
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.imageView.image = nil
    self.editButton.isHidden = true
    self.addButtonTap = nil
    self.editButtonTap = nil
  }
}
