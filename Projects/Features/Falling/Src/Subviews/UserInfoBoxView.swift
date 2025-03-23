//
//  UserInfoBoxView.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import DSKit
import FallingInterface
import Domain

final class UserInfoBoxView: TFBaseView {
//  lazy var pageControl: UIPageControl = {
//    let pageControl = UIPageControl()
//    pageControl.pageIndicatorTintColor = DSKitAsset.Color.neutral50.color
//    pageControl.currentPageIndicatorTintColor = DSKitAsset.Color.neutral300.color
//    return pageControl
//  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtEx4Sb
    label.setTextWithLineHeight(text: "닉네임", lineHeight: 29)
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
    label.setTextWithLineHeight(text: "주소", lineHeight: 17)
    return label
  }()
  
  private lazy var adressStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 6
    stackView.alignment = .leading
    return stackView
  }()
  
  lazy var infoButton = CardButton(type: .info)
  lazy var rejectButton = CardButton(type: .reject)
  lazy var likeButton = CardButton(type: .like)
  
  private lazy var spacerView = UIView()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 20
    stackView.alignment = .leading
    return stackView
  }()
  
  override func makeUI() {
    adressStackView.addArrangedSubviews([pinImageView, addressLabel])
    pinImageView.snp.makeConstraints {
      $0.height.equalTo(18)
      $0.width.equalTo(16)
    }
    
    labelStackView.addArrangedSubviews([titleLabel, adressStackView])
    
    addSubviews([labelStackView, buttonStackView])// , pageControl])

    labelStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(labelStackView.snp.bottom).offset(14)
      $0.leading.trailing.equalToSuperview()
    }
    
    [infoButton, spacerView, rejectButton, likeButton].forEach { subView in
      buttonStackView.addArrangedSubview(subView)
      subView.snp.makeConstraints {
        $0.size.equalTo(58)
      }
    }
    
    spacerView.snp.remakeConstraints {
      $0.height.equalTo(58)
      $0.width.equalTo(92).priority(.low)
    }
    
//    pageControl.snp.makeConstraints {
//      $0.top.equalTo(buttonStackView.snp.bottom).offset(14)
//      $0.centerX.equalToSuperview()
//      $0.height.equalTo(6)
//      $0.width.greaterThanOrEqualTo(38)
//    }
  }
  
  func bind(_ viewModel: FallingUser) {
    self.titleLabel.text = viewModel.username + ", \(viewModel.age)"
    self.addressLabel.text = viewModel.address
  }
}

#if DEBUG
import SwiftUI

struct UserInfoBoxViewRepresentable: UIViewRepresentable {
  typealias UIViewType = UserInfoBoxView
  
  func makeUIView(context: Context) -> UIViewType {
    return UIViewType()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
}
struct UserInfoBoxViewPreview: PreviewProvider {
  static var previews: some SwiftUI.View {
    Group {
      UserInfoBoxViewRepresentable()
        .frame(width: UIScreen.main.bounds.width, height: 600)
    }
    .previewLayout(.sizeThatFits)
    .padding(10)
  }
}
#endif
