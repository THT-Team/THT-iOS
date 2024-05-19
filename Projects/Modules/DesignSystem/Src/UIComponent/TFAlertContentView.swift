//
//  TFAlertContentView.swift
//  DSKit
//
//  Created by SeungMin on 4/29/24.
//

import UIKit

public final class TFAlertContentView: TFBaseView {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 24
    return stackView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "어떤 문제가 있나요?"
    label.font = UIFont.thtH5Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.numberOfLines = 0
    return label
  }()
  
  let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20
    return stackView
  }()
  
  public let unpleasantPhotoButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle("불괘한 사진", for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }()
  
  public let fakeProfileButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle("허위 프로필", for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }()
  
  public let photoTheftButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle("사진 도용", for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }()
  
  public let profanityButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle("욕설 및 비방", for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }()
  
  public let sharingIllegalFootageButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle("불법 촬영물 공유", for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }()
  
  public override func makeUI() {
    addSubview(stackView)
    stackView.addArrangedSubviews([titleLabel, buttonStackView])
    
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    buttonStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    buttonStackView.addArrangedSubviews([
      unpleasantPhotoButton,
      fakeProfileButton,
      photoTheftButton,
      profanityButton,
      sharingIllegalFootageButton
    ])
  }
}
