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
  }

  lazy var editButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.editCircle.image, for: .normal)
    $0.isHidden = true
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
    if let data = viewModel.data {
      self.imageView.image = UIImage(data: data)
    } else {
      self.imageView.image = nil
    }

    self.editButton.isHidden = self.imageView.image == nil

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

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PhotoHeaderViewCellPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let comp =  PhotoHeaderViewCollectionViewCell()
      comp.bind(.init(data: DSKitAsset.Image.Test.test1.image.pngData()!, cellType: .required))
      return comp
    }
    .frame(width: 106, height: 140)
    .previewLayout(.sizeThatFits)
  }
}
#endif
