//
//  UserInfoBoxView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import DSKit
import FallingInterface

final class UserInfoBoxView: TFBaseView {
  lazy var tagCollectionView: TagCollectionView = {
    let tagCollection = TagCollectionView()
    tagCollection.layer.cornerRadius = 20
    tagCollection.clipsToBounds = true
    tagCollection.collectionView.backgroundColor = DSKitAsset.Color.DimColor.default.color
    tagCollection.isHidden = true
    return tagCollection
  }()
  
  lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = 3
    pageControl.currentPageIndicatorTintColor = DSKitAsset.Color.neutral50.color
    pageControl.tintColor = DSKitAsset.Color.neutral300.color
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
    imageView.image = DSKitAsset.Image.Icons.pinSmall.image
    return imageView
  }()
  
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
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
  
  lazy var infoButton = CardButton(type: .info)
  
  lazy var refuseButton = CardButton(type: .refuse)
  
  lazy var likeButton = CardButton(type: .like)
  
  private lazy var spacerView = UIView()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    return stackView
  }()
  
  override func makeUI() {
    addSubviews([tagCollectionView,
                 vStackView, buttonStackView, pageControl])
    
    [infoButton, spacerView, refuseButton, likeButton].forEach { subView in
      buttonStackView.addArrangedSubview(subView)
      subView.snp.makeConstraints {
        $0.size.equalTo(80)
      }
    }
    
    spacerView.snp.remakeConstraints {
      $0.height.equalTo(80)
      $0.width.equalTo(90).priority(.low)
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
      $0.bottom.equalTo(pageControl).inset(14)
    }
    
    pageControl.snp.makeConstraints {
      $0.width.equalTo(38)
      $0.height.equalTo(6)
      $0.center.equalToSuperview()
      $0.bottom.equalToSuperview().inset(12)
    }
  }
  
  func bind(_ viewModel: FallingUser) {
    self.titleLabel.text = viewModel.username + ", \(viewModel.age)"
    self.addressLabel.text = viewModel.address
    self.tagCollectionView.sections = [
      ProfileInfoSection(header: "이상형", items: viewModel.idealTypeResponseList),
      ProfileInfoSection(header: "흥미", items: viewModel.interestResponses),
      ProfileInfoSection(header: "자기소개", introduce: viewModel.introduction)
    ]
  }
}

#if DEBUG
import SwiftUI

struct CarouselViewRepresentable: UIViewRepresentable {
  typealias UIViewType = UserInfoBoxView
  
  func makeUIView(context: Context) -> UIViewType {
    return UIViewType()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
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
