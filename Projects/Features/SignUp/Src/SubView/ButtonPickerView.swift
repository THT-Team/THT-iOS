//
//  ButtonPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import DSKit

class ButtonPickerView: UIControl {

  private let title: String
  private let targetString: String
  private let option1: String
  private let option2: String

  var tapAction: (() -> ())?

  var selectedOption: ButtonOption? = nil {
    didSet {
      if let selectedOption {
        changeButtonStatus(option: selectedOption)
        sendActions(for: .valueChanged)
      }
    }
  }

  enum ButtonOption {
    case left
    case right
  }

  init(title: String, targetString: String, option1: String, option2: String) {
    self.title = title
    self.targetString = targetString
    self.option1 = option1
    self.option2 = option2

    super.init(frame: .zero)

    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = title
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH1B
    $0.asColor(targetString: targetString, color: DSKitAsset.Color.neutral50.color)
  }

  lazy var buttonHStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.addArrangedSubviews([option1Btn, option2Btn])
    $0.distribution = .fillEqually
    $0.alignment = .fill
    $0.spacing = 10
  }

  lazy var option1Btn = CTAButton(btnTitle: option1, initialStatus: false)

  lazy var option2Btn = CTAButton(btnTitle: option2, initialStatus: false)

  func makeUI() {

    addSubviews(
      titleLabel,
      buttonHStackView
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(frame.height * 0.09)
      $0.leading.trailing.equalToSuperview().inset(38)
    }

    buttonHStackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-10)
    }

    option1Btn.addAction(UIAction { [weak self] _ in
      self?.selectedOption = .left
    }, for: .touchUpInside)

    option2Btn.addAction(UIAction { [weak self] _ in
      self?.selectedOption = .right
    }, for: .touchUpInside)
  }

  func handleSelectedState(_ option: ButtonOption) {
    self.selectedOption = option
  }

  func changeButtonStatus(option: ButtonOption) {
    switch option {
    case .left:
      option1Btn.updateColors(status: true)
      option2Btn.updateColors(status: false)
    case .right:
      option1Btn.updateColors(status: false)
      option2Btn.updateColors(status: true)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import DSKit

struct ButtonPickerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let text = "성별, 생일을 입력해주세요"
      let target = "성별, 생일"

      return ButtonPickerView(title: text, targetString: target, option1: "여자", option2: "남자")
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
