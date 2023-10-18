//
//  ProfileCollectionView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import UIKit

import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 20
    imageView.layer.masksToBounds = true
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    contentView.addSubview(imageView)

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.imageView.image = nil
  }

  func bind(imageURL: String) {
    guard let url = URL(string: imageURL) else {
      return
    }
    self.imageView.image = UIImage(named: "test_1", in: FallingResources.bundle, compatibleWith: nil)

//    self.imageView.setResource(url) { [weak self] in
//      self?.imageView.sizeToFit()
//      self?.imageView.layoutIfNeeded()
//    }
  }
}
