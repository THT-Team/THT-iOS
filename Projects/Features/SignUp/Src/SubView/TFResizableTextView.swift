//
//  TFResizableTextView.swift
//  SignUp
//
//  Created by kangho lee on 4/27/24.
//

import UIKit

import DSKit

import RxSwift

public class TFResizableTextView: UIControl {
  private let maxHeight: CGFloat = 120
  private let minHeight: CGFloat = 40
  private var totalCount: Int = 20
  
  enum State {
    case text(text: String?)
    case error(error: InputError)
    case focus
    case focusOut
  }
  
  enum InputError: Error {
    case validate(text: String)
    case overflow
  }
  
  var text: String? {
    set {
      self.textView.text = newValue
    } get {
      return self.textView.text
    }
  }
  
  var placeholder: String? {
    didSet {
      placeholderLabel.text = placeholder
    }
  }
  
  private lazy var placeholderLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.disabled.color
    $0.font = .thtSubTitle1R
    $0.backgroundColor = .clear
  }
  
  lazy var textView = ResizableTextView().then {
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtSubTitle1R
    $0.isScrollEnabled = false
    $0.isEditable = true
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
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
    $0.text = "(0/\(totalCount)"
    $0.font = .thtCaption1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }
  
  public init(description: String = "", totalCount: Int = 20, placeholder: String? = nil) {
    self.totalCount = totalCount
    super.init(frame: .zero)
    self.descLabel.text = description
    
    makeUI()
    bindAction()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
    addSubviews(
      textView, clearBtn,
      placeholderLabel,
      divider,
      errorDescriptionLabel,
      infoImageView, descLabel, countLabel
    )
    
    textView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(clearBtn.snp.leading)
    }
    
    clearBtn.snp.makeConstraints {
      $0.leading.equalTo(textView.snp.trailing)
      $0.bottom.equalTo(textView)
      $0.trailing.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    placeholderLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(textView)
      $0.height.equalTo(40)
    }

    divider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textView.snp.bottom).offset(2)
      $0.height.equalTo(2)
    }

    errorDescriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(divider.snp.bottom)
      $0.height.equalTo(20).priority(.low)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(textView)
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
  }
  
  func bindAction() {
    textView.delegate = self
    
    clearBtn.addAction(UIAction(handler: { [weak self] _ in
      self?.text = ""
      self?.clearBtn.isHidden = true
      self?.sendActions(for: .editingChanged)
      self?.checkPlaceholderLabel("")
    }), for: .touchUpInside)

    updateDividerColor(.focusOut)
  }
  
  private func calculateCount(count: Int) {
    let fullText = "(\(count)/\(totalCount))"
    let target = "\(count)"
    self.countLabel.text = fullText
    self.countLabel.asFont(targetString: target, font: .thtCaption1B)

    if count > totalCount {
      self.render(state: .error(error: .overflow))
      if let text {
        let endIndex = text.index(text.startIndex, offsetBy: 200)
        let range = text[text.startIndex..<text.index(before: endIndex)]
        self.text = String(range)
      }
    }
  }
  
  func render(state: State) {
    switch state {
    case let .text(text):
      self.errorDescriptionLabel.isHidden = true
      self.text = text
      self.errorDescriptionLabel.text = ""

    case .error(let inputError):
      self.updateErrorView(inputError)
    default: break
    }
  }
  
  private func updateDividerColor(_ state: State) {
    switch state {
    case .error:
      self.divider.backgroundColor = DSKitAsset.Color.error.color
    case .focus:
      self.divider.backgroundColor = DSKitAsset.Color.primary500.color
    default:
      self.divider.backgroundColor = self.textView.text.isEmpty
      ? DSKitAsset.Color.neutral300.color
      : DSKitAsset.Color.primary500.color
    }
    self.clearBtn.isHidden = self.textView.text.isEmpty
  }

  private func updateErrorView(_ inputError: InputError) {
    self.errorDescriptionLabel.isHidden = false

    if case let .validate(description) = inputError {
      self.errorDescriptionLabel.text = description
      self.countLabel.asColor(targetString: "\(self.text?.count ?? 0)", color: DSKitAsset.Color.neutral400.color)
    }
    if case .overflow = inputError {
      self.errorDescriptionLabel.text = "\(self.totalCount)자 이상 입력할 수 없습니다."
      self.countLabel.asColor(targetString: "\(self.text?.count ?? 0)", color: DSKitAsset.Color.error.color)
      }
    updateDividerColor(.error(error: inputError))
  }
}
extension TFResizableTextView: UITextViewDelegate {
  public func textViewDidBeginEditing(_ textView: UITextView) {
    updateDividerColor(.focus)
    
    checkPlaceholderLabel(textView.text)
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    updateDividerColor(.focusOut)
    
    checkPlaceholderLabel(textView.text)
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    self.calculateCount(count: textView.text.count)
    self.sendActions(for: .valueChanged)
    updateDividerColor(.text(text: textView.text))
    checkPlaceholderLabel(textView.text)
  }
  
  private func checkPlaceholderLabel(_ text: String) {
    if text.isEmpty {
      placeholderLabel.isHidden = false
    } else {
      placeholderLabel.isHidden = true
    }
  }
}
extension Reactive where Base: TFResizableTextView {
  var text: ControlProperty<String?> {
    self.base.textView.rx.text
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFResizableTextViewPreview: PreviewProvider {
  
  static var previews: some View {
    UIViewPreview {
      let component = TFResizableTextView()
      return component
    }
    .frame(width: 375, height: 120)
    .previewLayout(.sizeThatFits)
  }
}
#endif

