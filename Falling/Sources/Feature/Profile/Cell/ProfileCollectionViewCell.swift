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
    imageView.contentMode = .scaleAspectFit
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
    contentView.backgroundColor = FallingAsset.Color.neutral600.color
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
    let random = ["test_1", "test_2"]
    self.imageView.image = UIImage(named: random.randomElement() ?? "test_1", in: FallingResources.bundle, compatibleWith: nil)

//    self.imageView.setResource(url) { [weak self] in
//      self?.imageView.sizeToFit()
//      self?.imageView.layoutIfNeeded()
//    }
  }
}
