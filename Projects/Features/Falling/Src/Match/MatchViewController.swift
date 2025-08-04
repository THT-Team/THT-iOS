//
//  MatchViewController.swift
//  Falling
//
//  Created by Kanghos on 2/6/25.
//

import UIKit

import DSKit

final class MatchViewController: TFBaseViewController {
  
  var onClick: ((String) -> Void)?
  var onCancel: (() -> Void)?
    
  private let chatRoomIndex: String
  
  let containerLabelStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 0
    view.alignment = .center
    return view
  }()
  
  let labelStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.spacing = 2
    view.alignment = .center
    return view
  }()
  
  let buttonStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 16
    view.alignment = .center
    return view
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let nicknameLabel = {
    let label = UILabel()
    label.font = .thtH2B
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  let nicknameWithSuffixLabel = {
    let label = UILabel()
    label.text = "님과"
    label.font = .thtH2R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  let titleLabel = {
    let label = UILabel()
    label.text = "작은 공감이 연결되었어요."
    label.font = .thtH2R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  let subTitleLabel = {
    let label = UILabel()
    label.text = "선택한 주제어를 꺼내 대화를 열어보세요."
    label.font = .thtSubTitle1Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  
  lazy var submitButton = SubmitButton(
    title: "대화 시작하기") { [weak self] in
      guard let self = self else { return }
      self.onClick?(self.chatRoomIndex)
    }
  
  lazy var closeButton = SubmitButton(
    title: "닫기",
    foreground: DSKitAsset.Color.neutral50.color,
    background: .clear,
    font: UIFont.thtSubTitle2M,
    cornerRadius: 0) { [weak self] in
      guard let self = self else { return }
      self.onCancel?()
    }
  
  init(_ imageURL: String, nickname: String, index: String) {
    self.chatRoomIndex = index
    super.init(nibName: nil, bundle: nil)
    
    bind(imageURL, nickname)
  }
  
  func bind(_ imageURL: String, _ nickname: String) {
    imageView.setImage(urlString: imageURL)
    nicknameLabel.text = nickname
  }
  
  override func makeUI() {
    self.view.addSubviews(
      imageView,
      containerLabelStackView,
      buttonStackView
    )
    
    containerLabelStackView.addArrangedSubviews([
      labelStackView,
      titleLabel,
      subTitleLabel
    ])
    
    containerLabelStackView.setCustomSpacing(10, after: titleLabel)
    
    labelStackView.addArrangedSubviews([
      nicknameLabel, nicknameWithSuffixLabel
    ])
    
    buttonStackView.addArrangedSubviews([
      submitButton,
      closeButton
    ])
    
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    containerLabelStackView.snp.makeConstraints {
      $0.top.equalTo(128)
      $0.directionalHorizontalEdges.equalToSuperview().inset(38)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(70)
      $0.centerX.equalToSuperview()
    }
    
    submitButton.snp.makeConstraints {
      $0.width.equalTo(312)
      $0.height.equalTo(54)
    }
  }
}
