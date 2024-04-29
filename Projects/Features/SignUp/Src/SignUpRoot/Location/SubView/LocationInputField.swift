//
//  LocationInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import UIKit

import DSKit

class LocationInputField: UIControl {

  private lazy var containView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = DSKitAsset.Color.neutral300.color.cgColor
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 12
  }

  private lazy var pinImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.pin.image.withTintColor(DSKitAsset.Color.neutral50.color, renderingMode: .alwaysOriginal)
  }
  private lazy var locationLabel = UILabel().then {
    $0.text = "서울시 강남구 대치동"
    $0.textColor = DSKitAsset.Color.disabled.color
    $0.font = .thtH5M
  }

  lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descLabel: UILabel = UILabel().then {
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 3
    $0.text = "내 주변의 친구들과 더 많은 대화를 나눌 수 있어요."
  }

  var location: String = "" {
    didSet {
      locationLabel.text = location
      locationLabel.textColor = DSKitAsset.Color.neutral50.color
      self.containView.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    }
  }

  init() {
    super.init(frame: .zero)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    addSubviews(
      containView,
      infoImageView, descLabel
    )

    containView.addSubviews(
      pinImageView, locationLabel
    )
    
    containView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }

    pinImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.centerY.equalTo(locationLabel)
      $0.size.equalTo(30)
    }

    locationLabel.snp.makeConstraints {
      $0.leading.equalTo(pinImageView.snp.trailing).offset(5)
      $0.top.equalToSuperview().offset(16)
      $0.bottom.trailing.equalToSuperview().offset(-16)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(containView)
      $0.size.equalTo(16)
      $0.top.equalTo(containView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview()
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.trailing.equalTo(containView)
      $0.centerY.equalTo(infoImageView)
    }
  }
}

extension LocationInputField {
  func bind(_ location: String) {
    self.location = location

  }
}

extension Reactive where Base: LocationInputField {
  var location: Binder<String> {
    return Binder(self.base) { view, location in
      view.bind(location)
    }
  }

  var tap: ControlEvent<Void> {
      controlEvent(.touchUpInside)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LocationInputFieldPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let component =  LocationInputField()
//      component.bind("서울시 성북구 성북동")
      return component
    }
    .previewLayout(.sizeThatFits)
    .frame(width: 375, height: 100)
  }
}
#endif
