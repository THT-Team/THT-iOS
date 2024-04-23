//
//  TFButtonPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import DSKit

class TFButtonPickerView: UIControl {
  enum TitleType {
    case header
    case sub
  }

  struct Option: Equatable {
    let key: Int
    let value: String
  }// = (key: Int, value: String)

  private let title: String
  private let targetString: String
  private var options: [CTAButton] = []

  var selectedOption: Option? = nil {
    didSet {
      if let selectedOption {
        changeButtonStatus(selectedOption)
        sendActions(for: .valueChanged)
      }
    }
  }

  private let titleType: TitleType

  init(title: String, targetString: String, options: Dictionary<Int, String>, titleType: TitleType = .header) {
    self.title = title
    self.targetString = targetString
    self.titleType = titleType

    super.init(frame: .zero)
    createButtons(options)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var titleLabel = UILabel().then {
    $0.text = title
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = self.titleType == .header ? .thtH1B : .thtH4M
    $0.asColor(targetString: targetString, color: DSKitAsset.Color.neutral50.color)
  }

  lazy var buttonHStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.alignment = .fill
    $0.spacing = 10
  }

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
  }

  func createButtons(_ pairs: Dictionary<Int, String>) {
    pairs.forEach { pair in
      let button = CTAButton(btnTitle: pair.value, initialStatus: false)
      button.addAction(UIAction { [weak self] _ in
        self?.handleSelectedState(Option(key: pair.key, value: pair.value))
      }, for: .touchUpInside)
      self.buttonHStackView.addArrangedSubview(button)
      self.options.append(button)
    }
  }

  func handleSelectedState(_ option: Option) {
    self.selectedOption = option
  }

  func changeButtonStatus(_ selectedOption: Option) {
    options.enumerated().forEach { (index, element) in
      if index == selectedOption.key {
        element.updateColors(status: true)
      } else {
        element.updateColors(status: false)
      }
    }
  }
}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//import DSKit
//
//struct ButtonPickerViewPreview: PreviewProvider {
//
//  static var previews: some View {
//    UIViewPreview {
//      let text = "성별, 생일을 입력해주세요"
//      let target = "성별, 생일"
//
//      return ButtonPickerView(title: text, targetString: target, option1: "여자", option2: "남자")
//    }
//    .previewLayout(.sizeThatFits)
//  }
//}
//#endif
