//
//  ProfileCollectionViewCell.swift
//  Falling
//
//  Created by SeungMin on 1/12/24.
//

import UIKit

import Core
import DSKit

final class ProfileCollectionViewCell: UICollectionViewCell {
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
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
    contentView.backgroundColor = DSKitAsset.Color.neutral600.color
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
    
    self.imageView.kf.setImage(with: url)
  }
}
