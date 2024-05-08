//
//  TFTextField.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import DSKit

// TODO: RxExtension 및 기존 프로퍼티 private
// TODO: textField focus
class TFTextField: UIControl {

  enum State {
    case text(text: String?)
    case error(error: InputError)
  }

  enum InputError: Error {
    case validate(text: String)
    case overflow
  }

  var text: String? {
    set {
      self.textField.text = newValue
      self.divider.backgroundColor = (newValue?.isEmpty ?? true) == false
      ? DSKitAsset.Color.primary500.color
      : DSKitAsset.Color.neutral300.color
      self.calculateCount(count: newValue?.count ?? 0)
    } get {
      return self.textField.text
    }
  }

  var placeholder: String? = nil {
    didSet {
      self.textField.placeholder = placeholder
    }
  }

  /// set Total Count
  private var totalCount: Int

  var hasText: Bool {
     return (text?.isEmpty ?? true) == false
  }

  lazy var textField: UITextField = UITextField().then {
    $0.placeholder = "입력"
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtH2B
//    $0.keyboardType = .numberPad
  }

  lazy var clearBtn: UIButton = UIButton().then {
    $0.setImage(DSKitAsset.Image.Icons.closeCircle.image, for: .normal)
    $0.setTitle(nil, for: .normal)
    $0.backgroundColor = .clear
    $0.isHidden = true
  }

  lazy var divider: UIView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral300.color
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
  }

  lazy var errorDescriptionLabel = UILabel().then {
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.error.color
    $0.textAlignment = .left
    $0.numberOfLines = 3
  }

  lazy var countLabel = UILabel().then {
    $0.text = "(0/12)"
    $0.font = .thtCaption1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }

  init(description: String = "", totalCount: Int = 20, placeholder: String? = nil) {
    self.totalCount = totalCount
    super.init(frame: .zero)
    self.descLabel.text = description
    self.placeholder = placeholder
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    addSubviews(
      textField, clearBtn,
      divider,
      errorDescriptionLabel,
      infoImageView, descLabel, countLabel
    )

    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
    }

    clearBtn.snp.makeConstraints {
      $0.leading.equalTo(textField.snp.trailing)
      $0.centerY.equalTo(textField)
      $0.trailing.equalToSuperview()
      $0.size.equalTo(24)
    }

    divider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textField.snp.bottom).offset(2)
      $0.height.equalTo(2)
    }

    errorDescriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(divider.snp.bottom)
      $0.height.equalTo(20).priority(.low)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(textField)
      $0.size.equalTo(16)
      $0.top.equalTo(errorDescriptionLabel.snp.bottom)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.trailing.equalTo(countLabel.snp.leading)
      $0.top.equalTo(infoImageView)
      $0.bottom.equalToSuperview()
    }

    countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    countLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.top.equalTo(descLabel)
    }

    calculateCount(count: 0)
    bindAction()
  }

  func bindAction() {
    clearBtn.addAction(UIAction(handler: { [weak self] _ in
      self?.textField.text = ""
      self?.clearBtn.isHidden = true
      self?.textField.sendActions(for: .editingChanged)
      self?.sendActions(for: .editingChanged)
    }), for: .touchUpInside)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.clearBtn.isHidden = self?.textField.text?.isEmpty == true
      self?.text = self?.textField.text
      self?.render(state: .text(text: self?.text))
      if let totalCount = self?.totalCount, let count = self?.text?.count, count > totalCount {
        self?.render(state: .error(error: InputError.overflow))
      }
      self?.sendActions(for: .editingChanged)
    }), for: .editingChanged)
  }
  
  override func becomeFirstResponder() -> Bool {
    self.textField.becomeFirstResponder()
  }

  func render(state: State) {
    switch state {
    case let .text(text):
      self.errorDescriptionLabel.isHidden = true
      self.text = text
      self.errorDescriptionLabel.text = ""

    case .error(let inputError):
      self.errorDescriptionLabel.isHidden = false
      self.divider.backgroundColor = DSKitAsset.Color.error.color

      if case let .validate(description) = inputError {
        self.errorDescriptionLabel.text = description
        self.countLabel.asColor(targetString: "\(self.text?.count ?? 0)", color: DSKitAsset.Color.neutral400.color)
      }
      if case .overflow = inputError {
        self.errorDescriptionLabel.text = "\(self.totalCount)자 이상 입력할 수 없습니다."
        self.countLabel.asColor(targetString: "\(self.text?.count ?? 0)", color: DSKitAsset.Color.error.color)
      }
    }
  }

  private func calculateCount(count: Int) {
    let fullText = "(\(count)/\(totalCount))"
    let target = "\(count)"
    self.countLabel.text = fullText
    self.countLabel.asFont(targetString: target, font: .thtCaption1B)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFTextFieldPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let component = TFTextField()
      component.render(state: .text(text: "닉네임닉네임"))
      component.render(state: .error(error: .overflow))
      component.render(state: .error(error: .validate(text: "중복된 닉네임입니다.")))
//      component.render(state: .text(text: nil))
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
