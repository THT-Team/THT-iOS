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
    imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }
  override func layoutSubviews() {
    super.layoutSubviews()

    guard let image = imageView.image else {
      return
    }
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

  func configure(imageURL: String) {
    guard let url = URL(string: imageURL) else {
      return
    }
    self.imageView.setResource(url) { [weak self] in
      TFLogger.view.notice("imageDownload 끝")
      let size = "\((self?.imageView.image?.size) ?? CGSize(width: 100, height: 100))"
      print(self?.imageView.image?.scale)
      TFLogger.view.debug("\(size)")
    }
  }
}
