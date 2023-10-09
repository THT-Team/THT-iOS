//
//  ProfileCollectionView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import UIKit

import SnapKit

class ProfileCarouselView: TFBaseView {
  var photos: [UserProfilePhoto] = [] {
    didSet {
      pageControl.currentPage = 0
      pageControl.numberOfPages = oldValue.count
      collectionView.reloadData()
    }
  }
  lazy var reportButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = FallingAsset.Image.reportFill.image.withTintColor(
      FallingAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = FallingAsset.Color.topicBackground.color
    button.configuration = config

    config.automaticallyUpdateForSelection = true
    return button
  }()
  lazy var tagCollectionView: TagCollectionView = {
    let tagCollection = TagCollectionView()
    tagCollection.layer.cornerRadius = 20
    tagCollection.clipsToBounds = true
    tagCollection.collectionView.backgroundColor = FallingAsset.Color.dimColor2.color
    tagCollection.isHidden = true
    return tagCollection
  }()
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(cellType: ProfileCollectionViewCell.self)
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = FallingAsset.Color.neutral50.color
    return collectionView
  }()

  lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPageIndicatorTintColor = .black
    return pageControl
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtEx4Sb
    return label
  }()

  private lazy var pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FallingAsset.Image.pinSmall.image
    return imageView
  }()
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = FallingAsset.Color.neutral50.color
    label.font = UIFont.thtP2M
    return label
  }()
  private lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([pinImageView, addressLabel])
    stackView.axis = .horizontal
    return stackView
  }()
  private lazy var vStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([titleLabel, hStackView])
    stackView.axis = .vertical
    stackView.alignment = .leading
    return stackView
  }()

  lazy var likeButton: UIButton = {
    let button = UIButton()
    var config = defaultButtonConfig()

    config.image = FallingAsset.Image.heartSelected.image.withTintColor(FallingAsset.Color.error.color)
    button.configuration = config

    return button
  }()

  lazy var refuseButton: UIButton = {
    let button = UIButton()
    var config = defaultButtonConfig()
    config.image = FallingAsset.Image.close.image
    config.preferredSymbolConfigurationForImage = .init(pointSize: 100)
    button.configuration = config

    return button
  }()

  func defaultButtonConfig() -> UIButton.Configuration {
    var config = UIButton.Configuration.plain()
    config.imagePlacement = .all
    config.cornerStyle = .capsule
    config.background.strokeColor = FallingAsset.Color.neutral50.color
    config.background.strokeWidth = 1.5
    config.background.backgroundColor = FallingAsset.Color.dimColor2.color
    return config
  }
  lazy var infoButton: UIButton = {
    let button = UIButton()
    var config = defaultButtonConfig()

    config.image = FallingAsset.Image.setting.image
    button.configuration = config

    return button
  }()
  private lazy var spacerView = UIView()
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()

  override func makeUI() {
    self.backgroundColor = .white
    addSubviews([
      collectionView, tagCollectionView, vStackView,
      buttonStackView, pageControl
                ])
    [infoButton, spacerView, refuseButton, likeButton].forEach { subView in
      buttonStackView.addArrangedSubview(subView)
      subView.snp.makeConstraints {
        $0.size.equalTo(80)
      }
    }
    spacerView.snp.remakeConstraints {
      $0.height.equalTo(80)
      $0.width.equalTo(100).priority(.low)
    }
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints {
      $0.size.equalTo(100)
      $0.center.equalToSuperview()
    }

    tagCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(300).priority(.low)
      $0.bottom.equalTo(vStackView.snp.top).offset(-10)
    }
    vStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-10)
    }
    buttonStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.bottom.equalToSuperview().offset(-30)
    }
  }

  func configure(_ userDomain: UserDomain) {
    self.photos = userDomain.userProfilePhotos
    self.titleLabel.text = userDomain.username + ", \(userDomain.age)"
    self.addressLabel.text = userDomain.address
    self.tagCollectionView.sections = [
      profileInfoSection(header: "이상형", items: userDomain.idealTypes),
      profileInfoSection(header: "흥미", items: userDomain.interests),
      profileInfoSection(header: "자기소개", introduce: userDomain.introduction)
    ]
  }
}

extension ProfileCarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.bounds.size// CGSize(width: 200, height: 100)
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileCollectionViewCell.self)
    let item = photos[indexPath.item]
    cell.configure(imageURL: item.url)
    return cell
  }
}

#if DEBUG
import SwiftUI

struct CarouselViewRepresentable: UIViewRepresentable {
    typealias UIViewType = ProfileCarouselView

    func makeUIView(context: Context) -> UIViewType {
      return UIViewType()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
      let items = [UserProfilePhoto(url: "http", priority: 1),
      UserProfilePhoto(url: "http", priority: 2),
      UserProfilePhoto(url: "http", priority: 3),]
//      uiView.configure(items)
    }
}
struct CarouselViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CarouselViewRepresentable()
            .frame(width: UIScreen.main.bounds.width, height: 600)
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
