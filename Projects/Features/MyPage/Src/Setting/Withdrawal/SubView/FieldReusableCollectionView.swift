//
//  FieldReusableCollectionView.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit

final class TFHeaderField: UICollectionReusableView {

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private lazy var otherLabel = UILabel().then {
    $0.text = "기타"
    $0.font = .thtSubTitle2R
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  fileprivate lazy var otherTextField = UITextField().then {
    $0.placeholder = "기타 의견을 적어주세요 :)"

    $0.font = .thtSubTitle2R
    $0.textColor = DSKitAsset.Color.neutral50.color
  }

  func makeUI() {
    let container = UIView()
    let topLine = UIView()
    topLine.backgroundColor = DSKitAsset.Color.neutral500.color

    let bottomLine = UIView()
    bottomLine.backgroundColor = DSKitAsset.Color.neutral500.color
    addSubview(container)
    container.addSubviews(otherLabel, otherTextField, topLine, bottomLine)
    container.backgroundColor = DSKitAsset.Color.neutral700.color
    container.snp.makeConstraints {
      $0.top.equalToSuperview().offset(42).priority(.high)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    topLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(otherLabel.snp.bottom)
      $0.height.equalTo(0.5)
    }

    bottomLine.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(0.5)
    }

    otherLabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
    }

    otherTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(otherLabel)
      $0.top.equalTo(otherLabel.snp.bottom)
      $0.height.equalTo(46)
      $0.bottom.equalToSuperview()
    }
  }
}

extension Reactive where Base: TFHeaderField {
  var text: ControlEvent<String> {
    let source = base.otherTextField.rx.text.orEmpty.asObservable()

    return ControlEvent(events: source)
  }
}

