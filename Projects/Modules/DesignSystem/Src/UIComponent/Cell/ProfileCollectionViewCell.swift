//
//  LikeProfileCollectionViewCell.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import Core

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
//    let random: [DSKitImages] = [DSKitAsset.Image.Test.test1, DSKitAsset.Image.Test.test2]
    
    self.imageView.kf.setImage(with: url)

//    self.imageView.setResource(url) { [weak self] in
//      self?.imageView.sizeToFit()
//      self?.imageView.layoutIfNeeded()
//    }
  }
}
